if status is-interactive
    # Commands to run in interactive sessions can go here
end

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
    set -ga PATH $HOME/go/bin
end

if test -d $HOME/.cargo
    set -ga PATH $HOME/.cargo/bin
end
