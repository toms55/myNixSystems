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


  home.file = {
    ".config/nvim/lua/custom/chadrc.lua".source = ./config/nvim/lua/custom/chadrc.lua;
  } // lib.mkIf (!isDarwin) {
    ".config/qtile/config.py" = {
      source = ./config/qtile/config.py;
    };
  };
}
