# edit this configuration file to define what should be installed on
# your system.  help is available in the configuration.nix(5) man page
# and in the nixos manual (accessible by running 'nixos-help').

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.tom = import ../home.nix;
    extraSpecialArgs = { inherit inputs; };  # Pass inputs to home.nix
  };

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    
    displayManager = {
      lightdm.enable = true;
    };
    
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
      ];
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics.enable = true;

  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;
  programs.xwayland.enable = true;
  programs.steam.enable = true;

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

  users.users.tom = {
    isNormalUser = true;
    description = "tom";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "libvirtd" "kvm" "lp"];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

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
    home-manager
    git

    ripgrep
    nodejs
    python3
    tree-sitter
    tree
    lua
    luajit
    fastfetch
    vscode
    python3Packages.notebook

    pkg-config
    unzip

    st-snazzy
    zsh

    poetry
    python3Packages.pip
    
    adwaita-icon-theme
    adw-gtk3

    brave
    firefox
    mullvad-browser

    spotify
    cava
    discord
    protonup

    zoom-us
    gimp
    anki-bin
    libreoffice

    calibre
    tor-browser-bundle-bin
    virt-manager

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
    egl-wayland

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
    
    xorg.xkill
    killall

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
    
    udiskie
  ];

  # environment.sessionVariables = {
  # };

  # this value determines the nixos release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. it's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # did you read the comment?
  }
