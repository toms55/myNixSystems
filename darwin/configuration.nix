{ config, pkgs, ... }:

{
  system.stateVersion = 4;

  system.primaryUser = "tom";
  nixpkgs.config.allowUnfree = true;

  system.defaults = {
    dock = {
      autohide = true;
      mineffect = "scale";
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      _FXSortFoldersFirst = true;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file://${builtins.getEnv "HOME"}/";
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    firefox
    discord
    spotify
  ];

  ids.gids.nixbld = 350;
}

