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
  i18n.defaultLocale = "en_US.UTF-8";
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

  # display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'sh -c \"sleep 1; qtile start --backend wayland\"'";
        user = "greeter";
      };
    };
  };

  environment.etc."backgrounds/my-wallpaper.jpg".source = "/home/tom/mySystem/config/wallpaper.jpg";

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
    powerManagement.enable = true;
  };

  boot.kernelParams = [ "nvidia_drm.modeset=1" ];
  
  # vm stuff
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # enable wayland support globally
  programs.xwayland.enable = true;

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
    # extraGroups = [ "networkmanager" "wheel" "video" "audio"];
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "libvirtd" "kvm"]; #VM 
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
    home-manager
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
    python3Packages.notebook
    rstudio
    clang-tools
    unzip

    alacritty
    zsh

    poetry
    python3Packages.pip
    
    adwaita-icon-theme
    adw-gtk3

    brave
    firefox
    
    spotify
    discord
    
    mono
    wineWowPackages.full

    zoom-us
    gimp
    anki-bin
    libreoffice

    calibre
    tor-browser-bundle-bin
    virt-manager

    # qtile
    python3Packages.qtile

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
    
    # nvidia specific for wayland
    egl-wayland

    udiskie
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.sessionVariables = {
    GTK_THEME = "adwaita:dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";

    XDG_SESSION_TYPE = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    XDG_CURRENT_DESKTOP = "qtile";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
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
