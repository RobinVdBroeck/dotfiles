#!/bin/bash
# ============================================================
# Secure Boot setup for Arch Linux (GRUB) via sbctl
# Dual boot with Windows — run this on Arch, as root or with sudo
# ============================================================
#
# BEFORE RUNNING:
#   1. Your BIOS Platform Key (PK) should be deleted/cleared in your
#      UEFI/BIOS settings so the system is in "Setup Mode".
#   2. Windows BitLocker Warning: If BitLocker is enabled on Windows,
#      enrolling custom keys will prompt for your 48-digit Recovery Key
#      on the next Windows boot. Have it handy!

set -e  # Stop immediately if any command fails

echo "### 1. Installing sbctl and dependencies ###"
sudo pacman -S --needed sbctl efibootmgr

echo "### 2. Checking Secure Boot & Setup Mode status ###"
if sbctl status | grep -q "Setup Mode: Enabled"; then
    echo "✓ Setup Mode is ENABLED. Proceeding..."
else
    echo "⚠️ WARNING: System is not in Setup Mode."
    echo "If key enrollment fails below, enter your UEFI/BIOS settings,"
    echo "go to Key Management, and select 'Delete Platform Key' or 'Clear PK'."
fi

echo "### 3. Generating custom keys ###"
if [ ! -f /usr/share/secureboot/keys/PK/PK.key ]; then
    sudo sbctl create-keys
else
    echo "✓ Custom keys already exist, skipping generation."
fi

echo "### 4. Clearing immutable flags from EFI variables ###"
# Linux kernels often mark efivars as immutable (-i) to prevent deletion.
# sbctl needs write access to enroll the keys.
sudo chattr -i /sys/firmware/efi/efivars/KEK-* /sys/firmware/efi/efivars/db-* 2>/dev/null || true

echo "### 5. Enrolling keys into UEFI (including Microsoft Keys for Dual-Boot) ###"
# The -m (--microsoft) flag is CRITICAL to keep Windows booting natively!
sudo sbctl enroll-keys -m

echo "### 6. Rebuilding GRUB bootloader ###"
sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --modules="tpm" --disable-shim-lock
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "### 7. Registering and signing boot files with sbctl ###"
# 'sbctl sign -s' signs the file AND saves it to the database for automatic pacman re-signing

# 7a. Sign primary GRUB binary
if [ -f /boot/EFI/GRUB/grubx64.efi ]; then
    echo "Signing GRUB bootloader..."
    sudo sbctl sign -s /boot/EFI/GRUB/grubx64.efi
fi

# 7b. Sign fallback EFI binary if present
if [ -f /boot/EFI/BOOT/BOOTX64.EFI ]; then
    echo "Signing EFI Fallback bootloader..."
    sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
fi

# 7c. Sign internal GRUB core images (core.efi, grub.efi) to pass sbctl verification
for g in /boot/grub/x86_64-efi/*.efi; do
    if [ -f "$g" ]; then
        echo "Signing GRUB module image: $g"
        sudo sbctl sign -s "$g"
    fi
done

# 7d. Sign all detected kernels (vmlinuz-linux, vmlinuz-linux-zen, etc.)
for k in /boot/vmlinuz-*; do
    if [ -f "$k" ]; then
        echo "Signing kernel: $k"
        sudo sbctl sign -s "$k"
    fi
done

echo ""
echo "### 8. Verifying setup ###"
sudo sbctl verify

echo ""
echo "============================================================"
echo "Setup complete!"
echo ""
echo "Next Steps:"
echo "1. Reboot into your MSI BIOS."
echo "2. Set Secure Boot to 'Enabled' / 'Standard'."
echo "3. Save changes (F10) and boot back into Arch or Windows!"
echo ""
echo "Note: sbctl automatically hooks into pacman. Kernel and GRUB"
echo "updates will be silently re-signed in the background."
echo "============================================================"
