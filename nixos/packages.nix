{ pkgs, ... }:

{
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
    gemini-cli
    claude-code
    gcc

    gamemode

    prettier

    pkg-config
    unzip
    zip

    st-snazzy
    zsh

    poetry
    python3Packages.pip

    adwaita-icon-theme
    adw-gtk3

    firefox
    brave
    lynx
    mullvad-browser

    spotify
    discord
    protonup-ng

    gimp
    anki-bin
    libreoffice
    zotero

    calibre
    tor-browser
    virt-manager

    rofi
    nh
    openrgb

    xwayland

    xclip
    scrot

    obs-studio

    mako
    libnotify

    pavucontrol
    pulsemixer
    playerctl
    pamixer

    xfce.thunar

    networkmanagerapplet

    htop

    xorg.xkill
    killall

    autorandr

    python3Packages.psutil
    python3Packages.pulsectl

    udiskie
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-38.8.4"
  ];
}
