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

  xdg.configFile."alacritty/alacritty.toml".source = ./config/alacritty.toml;

  programs.neovim.enable = true;

  xdg.configFile."nvim/lua/custom/chadrc.lua".source = ./config/nvim/lua/custom/chadrc.lua;

  xdg.configFile."nvim/lua/custom/plugins/init.lua".source = ./config/nvim/lua/custom/plugins/init.lua;
  xdg.configFile."nvim/lua/custom/mappings.lua".source = ./config/nvim/lua/custom/mappings.lua;

};
}
