{ config, pkgs, ... }: {
  home = {
    stateVersion = "24.05";
    packages = with pkgs; [
      # Base compiler and build tools
      gnumake
      gcc

      git
      neovim
      tmux

    ];

    file = {
      ".tmux.conf".source = ./tmux/tmux.conf;
      ".config/nvim".source = ./nvim;
    };
  };

  programs = {
    zsh = {
      enable = true;

      shellAliases = {
        vim = "nvim";
      };

    shellAliases = {
          ls= "ls --color=auto";
          dir= "dir --color=auto";
          vdir="vdir --color=auto";
          grep="grep --color=auto";
          fgrep="fgrep --color=auto";
          egrep="egrep --color=auto";
    };

      # Set the zsh completion and history options
      initExtra = ''
        # Setup autocmplete
        fpath+=$HOME/.zfunc
        autoload -Uz compinit && compinit
        zstyle ':completion:*' menu select
        zstyle ':completion::complete:*' gain-privileges 1

        # Setup reverse search
        bindkey -v
        bindkey '^R' history-incremental-search-backward

        # Setup history, see https://jdhao.github.io/2021/03/24/zsh_history_setup/
        export HISTFILE="$HOME/.history"
        export HISTSIZE=100000 # how many lines in memory
        export SAVEHIST=$HISTSIZE #  How many lines in history files
        setopt SHARE_HISTORY
        setopt EXTENDED_HISTORY
        setopt HIST_EXPIRE_DUPS_FIRST
        setopt HIST_FIND_NO_DUPS
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_IGNORE_DUPS
        setopt HIST_IGNORE_SPACE
        setopt HIST_SAVE_NO_DUPS

        # Enable colors
        export CLICOLOR=1
        if [[ -x "$(command -v dircolors)" ]]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
          alias ls='ls --color=auto'
          alias dir='dir --color=auto'
          alias vdir='vdir --color=auto'
          alias grep='grep --color=auto'
          alias fgrep='fgrep --color=auto'
          alias egrep='egrep --color=auto'
        fi

        # Preferred editor for local and remote sessions
        if [[ -n $SSH_CONNECTION ]]; then
           export EDITOR='vim'
        else
           alias vim="nvim"
           export EDITOR='nvim'
        fi

        # Add local bin to path
        if [[ -d "$HOME/.local/bin" ]]; then
            export PATH="$HOME/.local/bin:$PATH"
        fi

        # setup zoxide
        if [[ -x "$(command -v zoxide)" ]]; then
            eval "$(zoxide init zsh)"
        fi

        # Setup fzf
        if [ -f ~/.fzf.zsh ]; then
            source ~/.fzf.zsh
        elif [ -d /usr/share/fzf ]; then
            source /usr/share/fzf/key-bindings.zsh
            source /usr/share/fzf/completion.zsh
        fi

        # setup fnm
        if [[ -x "$(command -v fnm)" ]]; then
            eval "$(fnm env --use-on-cd)"
        fi

        # bun completions
        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

        # Setup for tmuxp
        export DISABLE_AUTO_TITLE='true'

        alias icat="kitty +kitten icat"

        ## Custom functions

        # stolen from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
        # Added support to only have 1 arugment
        # -z = empty string
        function grename() {
          if [[ -z "$1" ]]; then
            echo "Usage: $0 <old_branch> new_branch"
            return 1
          fi

          if [[ -z "$2" ]]; then
              source="$(git rev-parse --abbrev-ref HEAD)"
              target="$1"
          else
              source="$1"
              target="$2"
          fi


          # Rename branch locally
          git branch -m "$source" "$target"

          # Rename branch in origin remote
          if git push origin :"$source"; then
            git push --set-upstream origin "$target"
          fi
        }
      '';
    };


    oh-my-posh = {
      enable = false;
      # TODO: configure own theme
      useTheme = "shell";
    };

    zoxide = {
      enable = true;
    };
  };
}
