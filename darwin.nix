{ pkgs, ... }:

{
  home = {
    username = "robin";
    homeDirectory = "/Users/robin";

    packages = with pkgs; [
    ];
  };
}

