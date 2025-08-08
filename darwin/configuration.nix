{ config, pkgs, ... }: {
  system.stateVersion = 4;
  system.primaryUser = "tom";
  nixpkgs.config.allowUnfree = true;
  users.users.tom = {
    name = "tom";
    home = "/Users/tom";
  };
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
  
  system.activationScripts.nvimConfig.text = ''
    echo "Setting up nvim configuration symlink..."
    
    USER_HOME="/Users/tom"
    
    # Ensure .config directory exists
    sudo -u tom mkdir -p "$USER_HOME/.config"
    
    # Remove existing nvim config if it exists and isn't already our symlink
    if [ -e "$USER_HOME/.config/nvim" ] && [ ! -L "$USER_HOME/.config/nvim" ]; then
      echo "Backing up existing nvim config to nvim.bak"
      sudo -u tom mv "$USER_HOME/.config/nvim" "$USER_HOME/.config/nvim.bak"
    fi
    
    # Create symlink if it doesn't exist
    if [ ! -L "$USER_HOME/.config/nvim" ]; then
      sudo -u tom ln -s "$USER_HOME/myNixSystems/config/nvim" "$USER_HOME/.config/nvim"
      echo "Created nvim config symlink"
    fi
  '';
  
  environment.systemPackages = with pkgs; [
    neovim
    git
    alacritty
    
    tree
    
    firefox
    brave
    discord
    spotify
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  ids.gids.nixbld = 350;
}
