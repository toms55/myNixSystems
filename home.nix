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

  xdg.configFile = 
    let
      nvimConfig = builtins.path { path = ./config/nvim/lua/custom/chadrc.lua; };
      qtileConfig = builtins.path { path = ./config/qtile/config.py; };
    in
    {
      "nvim/lua/custom/chadrc.lua".source = nvimConfig;
    } // lib.mkIf (!isDarwin) {
    "qtile/config.py" = {
      source = qtileConfig;
      force = true;
    };
  };
}
