{ system, username }: { pkgs, ... }: {

  home-manager.useUserPackages = true;
  home-manager.users.${username} = {
    inherit username;
    home.homeDirectory = if system == "darwin" then "/Users/${username}" else "/home/${username}";
    home.stateVersion = "23.11";

    programs.alacritty.enable = true;

    xdg.configFile."alacritty/alacritty.toml".source = ./config/alacritty.toml;
  
  };
}

