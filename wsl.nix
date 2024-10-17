{ pkgs, ... }: {
  home = {
    username = "robin";
    homeDirectory = "/home/robin";

    packages = with pkgs; [
      htop
    ];
  };
}

