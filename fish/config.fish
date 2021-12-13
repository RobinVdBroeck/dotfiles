if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gp PATH (systemd-path user-binaries)

if test -x (command -s nvim)
    set -Ux EDITOR nvim
else if test -x (command -s vim)
    set -Ux EDITOR vim
else if test -x (command -s nano)
    set -Ux EDITOR nano
else
    echo "No editor found"
end

if test -d $HOME/go/bin
    set -gp PATH $HOME/go/bin
end
