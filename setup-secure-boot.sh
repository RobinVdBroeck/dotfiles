#!/bin/bash
# ============================================================
# Secure Boot setup for Arch Linux (GRUB) via shim-signed
# Dual boot with Windows — run this on Arch, as root or with sudo
# ============================================================
#
# BEFORE RUNNING:
#   1. Confirm your bootloader ID / path is correct:
#        efibootmgr -v
#      You confirmed yours is: /boot/EFI/GRUB/grubx64.efi
#
#   2. Confirm your disk device name (NOT partition, the whole disk):
#        lsblk
#      e.g. /dev/nvme0n1 or /dev/sda — EDIT the DISK variable below.
#
#   3. Confirm your EFI partition number (usually 1):
#        lsblk -o NAME,PARTLABEL,SIZE
#      EDIT the PART variable below if it's not 1.
#
#   4. Secure Boot should currently be ENABLED in firmware, in
#      "Standard/Default" key mode (not Setup Mode / Custom).
#      This script does NOT touch the firmware's own key database —
#      it only enrolls a key into shim's separate MOK list.

set -e  # stop immediately if any command fails

# ---- EDIT THESE TWO VARIABLES FIRST ----
DISK="/dev/sdX"     # e.g. /dev/nvme0n1 -- your whole disk, not a partition
PART="1"            # EFI system partition number
# -----------------------------------------

echo "### 0. Safety checks on DISK and PART ###"

# 0a. Make sure the placeholder was actually edited
if [ "$DISK" = "/dev/sdX" ]; then
    echo "ERROR: You must edit the DISK variable at the top of this script"
    echo "       before running it. Check 'lsblk' to find your disk, e.g."
    echo "       /dev/nvme0n1 or /dev/sda (the whole disk, not a partition)."
    exit 1
fi

# 0b. DISK must exist and be a whole block device, not a partition
if [ ! -b "$DISK" ]; then
    echo "ERROR: '$DISK' does not exist or is not a block device."
    echo "       Run 'lsblk' and set DISK to your actual disk."
    exit 1
fi

if [ "$(lsblk -no TYPE "$DISK" 2>/dev/null)" != "disk" ]; then
    echo "ERROR: '$DISK' is not a whole disk (it looks like a partition"
    echo "       or something else). DISK should be e.g. /dev/nvme0n1,"
    echo "       not /dev/nvme0n1p1. Check 'lsblk'."
    exit 1
fi

# 0c. PART must be a positive integer
if ! [[ "$PART" =~ ^[0-9]+$ ]]; then
    echo "ERROR: PART must be a plain number (e.g. 1), got '$PART'."
    exit 1
fi

# 0d. The DISK+PART combination must actually exist as a partition
# Handles both naming schemes: /dev/sda1 and /dev/nvme0n1p1
if [[ "$DISK" =~ [0-9]$ ]]; then
    TARGET_PART="${DISK}p${PART}"
else
    TARGET_PART="${DISK}${PART}"
fi

if [ ! -b "$TARGET_PART" ]; then
    echo "ERROR: Partition '$TARGET_PART' does not exist."
    echo "       Run 'lsblk' and double check DISK and PART together"
    echo "       point at your EFI system partition."
    exit 1
fi

# 0e. That partition should actually be the ESP mounted at /boot (or /boot/efi)
BOOT_SRC="$(findmnt -no SOURCE /boot 2>/dev/null || findmnt -no SOURCE /boot/efi 2>/dev/null)"
if [ -z "$BOOT_SRC" ]; then
    echo "WARNING: Could not determine what device is mounted at /boot or"
    echo "         /boot/efi. Proceeding, but double check '$TARGET_PART'"
    echo "         is really your EFI system partition before continuing."
elif [ "$(readlink -f "$BOOT_SRC")" != "$(readlink -f "$TARGET_PART")" ]; then
    echo "ERROR: '$TARGET_PART' does not match the device actually mounted"
    echo "       at your boot partition ($BOOT_SRC)."
    echo "       DISK/PART would point efibootmgr at the wrong partition."
    echo "       Fix DISK/PART to match $BOOT_SRC and re-run."
    exit 1
fi

# 0f. Partition table should be GPT (required for UEFI boot entries)
PTTYPE="$(lsblk -no PTTYPE "$DISK" 2>/dev/null)"
if [ "$PTTYPE" != "gpt" ]; then
    echo "ERROR: '$DISK' has partition table type '$PTTYPE', expected 'gpt'."
    echo "       UEFI/Secure Boot requires a GPT-partitioned disk."
    exit 1
fi

echo "Safety checks passed: DISK=$DISK PART=$PART -> $TARGET_PART"
echo "(matches boot device: ${BOOT_SRC:-unknown, see warning above})"
echo ""

echo "### 0g. Detecting installed kernel(s) ###"
# Finds every vmlinuz-* in /boot so this works whether you use linux,
# linux-zen, linux-lts, linux-hardened, or several side by side.
mapfile -t KERNELS < <(find /boot -maxdepth 1 -name 'vmlinuz-*' -printf '%f\n')

if [ ${#KERNELS[@]} -eq 0 ]; then
    echo "ERROR: No vmlinuz-* files found in /boot. Is a kernel installed?"
    exit 1
fi

echo "Found kernel(s): ${KERNELS[*]}"
echo ""

echo "### 1. Installing required packages ###"
# shim-signed: Microsoft-signed loader that firmware already trusts
# sbsigntools: tools to sign GRUB/kernel with your own key
# efibootmgr:  manage UEFI boot entries
# mokutil:     enroll your key into shim's trust list (MOK)
sudo pacman -S --needed shim-signed sbsigntools efibootmgr mokutil

echo "### 2. Generating your own signing key pair ###"
# This key will sign GRUB and the kernel. Shim will be told to trust it.
sudo mkdir -p /etc/secureboot/keys
cd /etc/secureboot/keys

if [ ! -f MOK.key ]; then
    sudo openssl req -newkey rsa:2048 -nodes -keyout MOK.key -new -x509 \
        -sha256 -days 3650 -subj "/CN=Arch Linux Secure Boot Key/" -out MOK.crt
    sudo openssl x509 -outform DER -in MOK.crt -out MOK.der
else
    echo "Key already exists, skipping generation."
fi

echo "### 3. Enrolling the key into MOK (Machine Owner Key list) ###"
# You will be prompted to set a temporary password.
# IMPORTANT: On next reboot, a blue "MokManager" screen will appear
# automatically — select "Enroll MOK", then "Continue", then enter
# that same password to confirm. This only happens once.
sudo mokutil --import /etc/secureboot/keys/MOK.der

echo "### 4. Copying shim and MokManager into the GRUB EFI directory ###"
if [ ! -d /boot/EFI/GRUB ]; then
    echo "ERROR: /boot/EFI/GRUB does not exist. Run grub-install first,"
    echo "       or check that your bootloader ID/path is actually GRUB."
    exit 1
fi
if [ ! -f /usr/share/shim-signed/shimx64.efi ] || [ ! -f /usr/share/shim-signed/mmx64.efi ]; then
    echo "ERROR: shim-signed files not found in /usr/share/shim-signed/."
    echo "       Check the shim-signed package installed correctly."
    exit 1
fi
sudo cp /usr/share/shim-signed/shimx64.efi /boot/EFI/GRUB/
sudo cp /usr/share/shim-signed/mmx64.efi /boot/EFI/GRUB/

echo "### 5. Signing grubx64.efi with your key ###"
sudo sbsign --key /etc/secureboot/keys/MOK.key --cert /etc/secureboot/keys/MOK.crt \
    --output /boot/EFI/GRUB/grubx64.efi /boot/EFI/GRUB/grubx64.efi

echo "### 6. Signing the installed kernel(s) ###"
for KERNEL in "${KERNELS[@]}"; do
    echo "Signing /boot/$KERNEL"
    sudo sbsign --key /etc/secureboot/keys/MOK.key --cert /etc/secureboot/keys/MOK.crt \
        --output "/boot/$KERNEL" "/boot/$KERNEL"
done

echo "### 7. Creating a new boot entry that points to shim, not GRUB directly ###"
# This adds a NEW entry — it does not overwrite your existing GRUB entry.
sudo efibootmgr --create --disk "$DISK" --part "$PART" \
    --loader '\EFI\GRUB\shimx64.efi' --label "Arch (Secure Boot)"

echo "### 8. Setting up a pacman hook to auto re-sign kernel(s) on updates ###"
# Without this, a kernel update overwrites vmlinuz-* with an unsigned file,
# and Secure Boot will refuse to boot it.
#
# Target uses a glob so this covers linux, linux-zen, linux-lts,
# linux-hardened, etc. -- not just the exact kernel(s) found today.
# The Exec command re-signs every vmlinuz-* in /boot, so it self-adapts
# if you install/remove kernel packages later.
sudo mkdir -p /etc/pacman.d/hooks
sudo tee /etc/pacman.d/hooks/95-secureboot-sign.hook > /dev/null <<'EOF'
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux*

[Action]
Description = Re-signing kernel(s) for Secure Boot...
When = PostTransaction
Exec = /bin/sh -c 'for k in /boot/vmlinuz-*; do /usr/bin/sbsign --key /etc/secureboot/keys/MOK.key --cert /etc/secureboot/keys/MOK.crt --output "$k" "$k"; done'
EOF

echo ""
echo "============================================================"
echo "Setup complete. Two manual steps remain:"
echo ""
echo "1. Check the new boot entry number:"
echo "     efibootmgr -v"
echo "   Then put it first in boot order (replace XXXX and keep the rest):"
echo "     sudo efibootmgr --bootorder XXXX,0001,0000,0002,0003"
echo ""
echo "2. Reboot. A blue MokManager screen will appear automatically:"
echo "     Enroll MOK -> Continue -> Yes -> enter the password from step 3"
echo "   After that one-time enrollment, it will boot straight through"
echo "   shim -> GRUB -> kernel silently every time."
echo "============================================================"
