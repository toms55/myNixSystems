{ config, pkgs, ... }:

{
  # Required version tag for nix-darwin; any number, does not affect packages
  system.stateVersion = 4;

  # Install Neovim and Git
  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  ids.gids.nixbld = 350;

  # Enable Zsh (default shell on macOS)
  programs.zsh.enable = true;
}
