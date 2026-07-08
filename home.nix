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

  home.packages = [ pkgs.neovim ];

  home.sessionVariables.EDITOR = "nvim";

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/mySystem/config/nvim";
    };
    ".config/awesome/rc.lua" = lib.mkIf (!isDarwin) {
      source = ./config/awesome/rc.lua;
    };
  };
}
