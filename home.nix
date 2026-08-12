{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  btHeadphonesMAC = "88:92:CC:3C:A0:A5";
in {
  home = {
    username = "tom";
    homeDirectory = if isDarwin then "/Users/tom" else "/home/tom";
    stateVersion = "23.11";
  };

  programs.zsh.enable = true;
  programs.alacritty.enable = true;

  home.packages = [ pkgs.neovim ];

  home.sessionVariables.EDITOR = "nvim";

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  systemd.user.services.bt-headphone-autoconnect = lib.mkIf (!isDarwin) {
    Unit = {
      Description = "Auto-connect Sony WH-CH720N Bluetooth headphones";
      After = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "bt-connect-headphones" ''
        MAC="${btHeadphonesMAC}"
        # Give bluetooth stack time to settle after login
        sleep 8
        for attempt in 1 2 3 4 5; do
          if ${pkgs.bluez}/bin/bluetoothctl connect "$MAC"; then
            exit 0
          fi
          sleep 6
        done
      ''}";
      RemainAfterExit = "yes";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/myNixSystems/config/nvim";
    };
    ".config/awesome/rc.lua" = lib.mkIf (!isDarwin) {
      source = ./config/awesome/rc.lua;
    };
  };
}
