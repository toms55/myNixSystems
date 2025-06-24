# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };
  
  # Diplay manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'qtile start --backend wayland'";
        user = "greeter";
      };
    };
  };

  environment.etc."backgrounds/my-wallpaper.jpg".source = "/home/tom/mySystem/config/wallpaper.jpg";

  # Create symlink for user's qtile config
  system.activationScripts.qtileConfig = ''
    mkdir -p /home/tom/.config
    ln -sfn /home/tom/mySystem/config/qtile /home/tom/.config/qtile
    chown -h tom:users /home/tom/.config/qtile
  '';
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    
    extraPackages = with pkgs; [
      vulkan-tools
      vulkan-headers
      vulkan-loader
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-tools
      vulkan-headers  
      vulkan-loader
      nvidia-vaapi-driver
    ];
  };
  
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.kernelParams = [ "nvidia_drm.modeset=1" ];

  # Enable Wayland support globally
  programs.xwayland.enable = true;

  # Screen sharing support for Discord/Zoom
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = "wlr";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
  services.dbus.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.tom = {
    isNormalUser = true;
    description = "Tom";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    optimise.automatic = true;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flags = ["--update" "--flake" "~/mySystem/nixos/configuration.nix"];
    allowReboot = false;
  };

  systemd.timers.nixos-auto-upgrade = {
    timerConfig.Persistent = true;
  };

fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
  nerd-fonts.jetbrains-mono
];

  environment.systemPackages = with pkgs; [
    wget
	  git
	  neovim
	  ripgrep
    nodejs
    python3
    tree-sitter
    tree
    lua
	  luajit
	  fastfetch
	  vscode
    python313Packages.notebook
    rstudio
	  clang-tools

    alacritty
    zsh

    poetry
    python313Packages.pip
    
    adwaita-icon-theme
    adw-gtk3

    brave
    firefox
    
    spotify
    discord
    vesktop
    steam
    gamemode
    gamescope

    zoom-us
    gimp
    anki-bin
    libreoffice

    calibre
    tor-browser-bundle-bin

    # Qtile
    python313Packages.qtile

    wofi
    nh

    wayland
    wayland-protocols
    wayland-utils
    xwayland
    

    # Clipboard and selection
    wl-clipboard
    clipman

    # Screenshot and screen recording
    grim
    slurp
    swappy
    wf-recorder
    obs-studio

    # Notification daemon
    mako
    libnotify

    # Screen sharing and portals
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk


    # Audio control
    pavucontrol
    pulsemixer
    playerctl
    pamixer

    # Brightness control
    brightnessctl
    wlsunset

    # File manager
    xfce.thunar

    # Image viewer
    imv
    feh

    # Network management
    networkmanagerapplet

    # System monitoring
    htop
    btop
    
    xorg.xkill

    # Additional utilities
    kanshi
    wdisplays
    gammastep
    
    # For Discord screen sharing specifically
    pipewire
    wireplumber

    wlr-randr
    swaybg
    swayidle
    swaylock

    python3Packages.psutil
    python3Packages.pulsectl
    
    # NVIDIA specific for Wayland
    egl-wayland

    udiskie
  ];

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
};

environment.variables = {
  LUA_PATH = "?;?/init.lua;/home/tom/.config/nvim/lua/?.lua;/home/tom/.config/nvim/lua/?/init.lua";
  # Wayland-specific environment variables
  XDG_SESSION_TYPE = "wayland";
  ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  QT_QPA_PLATFORM = "wayland";
  GDK_BACKEND = "wayland";
  SDL_VIDEODRIVER = "wayland";
  CLUTTER_BACKEND = "wayland";
  # NVIDIA specific for Wayland
  LIBVA_DRIVER_NAME = "nvidia";
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  # WLR_NO_HARDWARE_CURSORS = "1";
  # For Discord screen sharing
  XDG_CURRENT_DESKTOP = "qtile";
  
  STEAM_FORCE_X11 = "1";
  WLR_NO_HARDWARE_CURSORS = "1";
  STEAM_GAMESCOPE = "gamescope -f --";
  EDITOR = "nvim";
};

environment.sessionVariables = {
  GTK_THEME = "Adwaita:dark";
  QT_STYLE_OVERRIDE = "Adwaita-Dark";

  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_DATA_HOME = "$HOME/.local/share";
  # Additional Wayland session variables
  NIXOS_OZONE_WL = "1";
  MOZ_ENABLE_WAYLAND = "1";
};

  # Security for screen sharing
  security.polkit.enable = true;

  # Enable location services for wlsunset/gammastep
  services.geoclue2.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
