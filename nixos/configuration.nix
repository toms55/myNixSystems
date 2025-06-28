# edit this configuration file to define what should be installed on
# your system.  help is available in the configuration.nix(5) man page
# and in the nixos manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # define your hostname.
  # networking.wireless.enable = true;  # enables wireless support via wpa_supplicant.

  # configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noproxy = "127.0.0.1,localhost,internal.domain";

  # enable networking
  networking.networkmanager.enable = true;

  # set your time zone.
  time.timeZone = "Australia/Sydney";

  i18n.defaultLocale = "en_GB.UTF-8";

  # diplay manager
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

  # create symlink for user's qtile config
  system.activationScripts.qtileconfig = ''
    mkdir -p /home/tom/.config
    ln -sfn /home/tom/mySystem/config/qtile /home/tom/.config/qtile
    chown -h tom:users /home/tom/.config/qtile
  '';
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # was driSupport32Bit

    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      vulkan-tools
      nvidia-vaapi-driver
    ];
  };
  
  # boot.kernelpackages = pkgs.linuxpackages_latest;

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.kernelParams = [ "nvidia_drm.modeset=1" ];
  
  #vm stuff
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # enable wayland support globally
  programs.xwayland.enable = true;

  # screen sharing support for discord/zoom
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

  # enable cups to print documents.
  services.printing.enable = true;

  # enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.dbus.enable = true;

  # define a user account. don't forget to set a password with 'passwd'.
  users.users.tom = {
    isNormalUser = true;
    description = "tom";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "libvirtd" "kvm"];
  };

  # flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  systemd.timers.nixos-auto-upgrade = {
    timerConfig.persistent = true;
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
    unzip

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
    virt-manager

    # qtile
    python313Packages.qtile

    wofi
    nh

    wayland
    wayland-protocols
    wayland-utils
    xwayland
    

    # clipboard and selection
    wl-clipboard
    clipman

    # screenshot and screen recording
    grim
    slurp
    swappy
    wf-recorder
    obs-studio

    # notification daemon
    mako
    libnotify

    # screen sharing and portals
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk


    # audio control
    pavucontrol
    pulsemixer
    playerctl
    pamixer

    # brightness control
    brightnessctl
    wlsunset

    # file manager
    xfce.thunar

    # image viewer
    imv
    feh

    # network management
    networkmanagerapplet

    # system monitoring
    htop
    btop
    
    xorg.xkill

    # additional utilities
    kanshi
    wdisplays
    gammastep
    
    # for discord screen sharing specifically
    pipewire
    wireplumber

    wlr-randr
    swaybg
    swaylock

    python3Packages.psutil
    python3Packages.pulsectl
    
    # nvidia specific for wayland
    egl-wayland

    udiskie
  ];

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    
    gamescopeSession.enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };

  };

programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
};
 environment.sessionVariables = {
  gtk_theme = "adwaita:dark";
  qt_style_override = "adwaita-dark";

  xdg_config_home = "$home/.config";
  xdg_cache_home = "$home/.cache";
  xdg_data_home = "$home/.local/share";

  xdg_session_type = "wayland";
  electron_ozone_platform_hint = "wayland";
  qt_qpa_platform = "wayland";
  gdk_backend = "wayland";
  sdl_videodriver = "wayland";
  clutter_backend = "wayland";
  libva_driver_name = "nvidia";
  gbm_backend = "nvidia-drm";
  __glx_vendor_library_name = "nvidia";
  xdg_current_desktop = "qtile";
  wlr_no_hardware_cursors = "1";
  steam_use_dynamic_vrs = "1";
  nixos_ozone_wl = "1";
  moz_enable_wayland = "1";
  editor = "nvim";
};
  # security for screen sharing
  security.polkit.enable = true;

  # enable location services for wlsunset/gammastep
  services.geoclue2.enable = true;

  # this value determines the nixos release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. it's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # did you read the comment?

}
