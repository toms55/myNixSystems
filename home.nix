# home.nix
{ config, pkgs, ... }:

{
  # All Home Manager specific options should be nested under the 'home' attribute
  home = {
    username = "tom";
    homeDirectory = if pkgs.stdenv.isDarwin
                    then "/Users/tom"
                    else "/home/tom";
    stateVersion = "23.11"; # This should match your home-manager release branch
  };

  # Other Home Manager programs and configurations can go here
  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.toml".source =
    ../config/alacritty.toml;
}
