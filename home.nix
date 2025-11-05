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

  # Enable neovim through home-manager
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.file = {
    ".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
    };
  } // lib.mkIf (!isDarwin) {
    ".config/awesome/rc.lua" = {
      source = ./config/awesome/rc.lua;
    };
  };
}
