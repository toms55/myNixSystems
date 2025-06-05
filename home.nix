{ config, pkgs, ... }:

{
  home = {
    username = "tom";
    homeDirectory = "/Users/tom";
    stateVersion = "23.11";
  };

  programs.zsh.enable = true;
  programs.alacritty.enable = true;

  xdg.configFile."alacritty/alacritty.toml".source = ./config/alacritty.toml;
}



