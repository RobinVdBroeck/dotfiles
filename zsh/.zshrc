# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    dotenv
)

if [[ -f $ZSH/oh-my-zsh.sh ]]; then
    source $ZSH/oh-my-zsh.sh
else
    echo "oh-my-zsh not loaded"
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Setup editor
if [[ -n $(command -v nvim) ]] then
    export EDITOR="nvim"
    alias vim="nvim"
elif [[ -n $(command -v vim) ]] then
    export EDITOR="vim"
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias reloadzsh="source ~/.zshrc"

# Setting for tmuxp
export DISABLE_AUTO_TITLE=true

# Make ctrl-s + ctrl-q not freeze the terminal, since I use those to save
# accidently alot
stty -ixon

# Prefer fnm over nvm
# See: https://github.com/Schniz/fnm
if [[ -d "$HOME/.fnm" ]] then
    export PATH="$HOME/.fnm":$PATH
    eval "`fnm env`"
else
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    if [[ -s "$NVM_DIR/nvm.sh" ]] then
        source "$NVM_DIR/nvm.sh" 
    fi
fi

# Pyenv
if [[ -d "$HOME/.pyenv" ]] then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Pipenv autocompletion
if [[ -x $(command -v pipenv) ]] then
    eval "$(pipenv --completion)"
fi

# Add RVM to PATH for scripting, or default ruby if we have that.
if [[ -d "$HOME/.rvm" ]] then
    export PATH="$PATH:$HOME/.rvm/bin"
elif which ruby >/dev/null && which gem >/dev/null; then
    export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi 

# Cargo
if [[ -d "$HOME/.cargo" ]] then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Sdk
if [[ -d "$HOME/.sdkman" ]] then
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# Dart setup
if [[ -n "$(command -v dart)" ]] then
    export PATH="$PATH:/usr/lib/dart/bin"
    export PATH="$PATH:$HOME/.pub-cache/bin"
fi
