{ config, pkgs, ... }: {
  home = {
    stateVersion = "24.05";
    packages = with pkgs; [
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
}
