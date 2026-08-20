{ config, pkgs, lib, hasBluetooth ? false, ... }:
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
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "None";
        padding = { x = 0; y = 0; };
        dynamic_padding = false;
      };
      colors = {
        primary = {
          background = "#1a1a1a";
          foreground = "#e0e0e0";
        };
        cursor = {
          text = "#1a1a1a";
          cursor = "#e0e0e0";
        };
        normal = {
          black = "#1a1a1a";
          red = "#a05050";
          green = "#5a8a5a";
          yellow = "#a0945a";
          blue = "#5a7a9a";
          magenta = "#8a6a9a";
          cyan = "#5a9a9a";
          white = "#e0e0e0";
        };
      };
      cursor.style.shape = "Block";
      terminal.shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [ "new-session" "-A" "-s" "main" ];
      };
    };
  };

  # `alacritty migrate` rewrites this file in place, replacing the Home Manager
  # symlink with a regular file and breaking the next activation. Overwrite it
  # unconditionally instead of failing on the leftover.
  xdg.configFile."alacritty/alacritty.toml".force = true;

  home.packages = [ pkgs.neovim pkgs.tmux ];

  home.sessionVariables.EDITOR = "nvim";

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  systemd.user.services.bt-headphone-autoconnect = lib.mkIf (!isDarwin && hasBluetooth) {
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
    ".tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/myNixSystems/config/tmux/tmux.conf";
    };
  };
}
