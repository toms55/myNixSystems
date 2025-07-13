{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in {
  home = {
    username = "tom";
    homeDirectory = if isDarwin then "/Users/tom" else "/home/tom";
    stateVersion = "23.11";
  };

  programs.zsh.enable = true;
  programs.alacritty.enable = true;
  programs.neovim.enable = true;

  # Let Home Manager manage the files
  xdg.configFile = {
    "alacritty/alacritty.toml" = {
      source = ./config/alacritty.toml;
      force = true;
    };
    "nvim/lua/custom/chadrc.lua".source = ./config/nvim/lua/custom/chadrc.lua;
  } // lib.mkIf (!isDarwin) {
    "qtile/config.py".source = ./config/qtile/config.py;
  };
}

