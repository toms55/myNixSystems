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

  # Enable greetd login manager
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

  # Link Qtile config from mySystem
  environment.etc."qtile-config".source = "/home/tom/mySystem/config/qtile";
  
  # Create symlink for user's qtile config
  system.activationScripts.qtileConfig = ''
    mkdir -p /home/tom/.config
    ln -sfn /home/tom/mySystem/config/qtile /home/tom/.config/qtile
    chown -h tom:users /home/tom/.config/qtile
  '';
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # This is required for Steam
    extraPackages = with pkgs; [
      vulkan-tools
      vulkan-headers
      vulkan-loader
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-tools
      vulkan-headers
      vulkan-loader
    ];
  };
  
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable Wayland support globally
  programs.xwayland.enable = true;

  # Screen sharing support for Discord/Zoom
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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

  # Install firefox.
  services.tor.enable = true;

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
    flags = ["-L" "--cleanup"];
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
	rstudio
	clang-tools

	alacritty
	zsh

	poetry

	xclip
	wl-clipboard

	brave
	firefox
	
	spotify
	discord
	steam
	zoom-us
	gimp
	anki-bin

	calibre
	tor-browser-bundle-bin

	# Qtile
	python313Packages.qtile

	dmenu

	# Essential Wayland utilities
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

	# PDF viewer
	zathura

	# Network management
	networkmanagerapplet

	# System monitoring
	htop
	btop
	
	# Additional utilities
	kanshi
	wdisplays
	gammastep
	
	# For Discord screen sharing specifically
	pipewire
	wireplumber

	wlr-randr
	swaybg

	python3Packages.psutil
	python3Packages.pulsectl
	
	# NVIDIA specific for Wayland
	egl-wayland

	udiskie
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
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
  QT_QPA_PLATFORM = "wayland";
  GDK_BACKEND = "wayland";
  SDL_VIDEODRIVER = "wayland";
  CLUTTER_BACKEND = "wayland";
  # NVIDIA specific for Wayland
  LIBVA_DRIVER_NAME = "nvidia";
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  WLR_NO_HARDWARE_CURSORS = "1";
  # For Discord screen sharing
  XDG_CURRENT_DESKTOP = "qtile";
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

  XCURSOR_THEME = "Bibata-Modern-Classic";
  XCURSOR_SIZE = "24";
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
