if test -d $HOME/.fnm
    set -ga PATH $HOME/.fnm
    fnm env | source
end

