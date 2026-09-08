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

  programs.tmux = {
    enable = true;
    mouse = false;
    escapeTime = 0;
    historyLimit = 50000;
    baseIndex = 1;
    keyMode = "vi";
    terminal = "tmux-256color";

    extraConfig = ''
      set -g focus-events on
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Windows/panes numbered from 1, like awesome's tags
      setw -g pane-base-index 1
      set -g renumber-windows on

      # vi-style status keys (mode-keys handled by keyMode above)
      set -g status-keys vi

      # j/k cycle pane focus (matches awesomewm's modkey+j/k client cycling)
      bind j select-pane -t :.+
      bind k select-pane -t :.-

      # Shift+hjkl to resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Shift+h/l to move windows left/right (mirrors awesome's modkey+shift swap)
      bind -r < swap-window -t -1 \; previous-window
      bind -r > swap-window -t +1 \; next-window

      # Splits that keep the current path (both the defaults and the mnemonic keys)
      bind | split-window -h -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # New window in the current path
      bind c new-window -c "#{pane_current_path}"

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded"

      # Minimal monochrome status bar, matching awesome's #333333 borders
      set -g status-style "bg=#1a1a1a,fg=#888888"
      set -g status-left ""
      set -g status-right "#[fg=#555555]%H:%M"
      set -g status-justify left
      setw -g window-status-current-style "fg=#e0e0e0,bold"
      setw -g window-status-format " #I:#W "
      setw -g window-status-current-format " #I:#W "
      set -g pane-border-style "fg=#333333"
      set -g pane-active-border-style "fg=#555555"
      set -g status-position bottom

      # Session persistence (tmux-resurrect + tmux-continuum).
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-save-interval '15'
      set -g @continuum-restore 'on'

      # MUST stay last: continuum reads @continuum-restore and appends its autosave
      # hook to status-right at load, so plugins must load after every option and
      # status-right line above. (Home Manager's `plugins` list loads them before
      # extraConfig, which would break this — hence the manual run-shell here.)
      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };

  home.packages = [ pkgs.neovim ];

  home.sessionVariables.EDITOR = "nvim";

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  systemd.user.services.bt-headphone-autoconnect = lib.mkIf (!isDarwin && hasBluetooth) {
    Unit = {
      Description = "Auto-connect Sony WH-CH720N Bluetooth headphones";
      Requires = [ "wireplumber.service" ];
      After = [ "wireplumber.service" "default.target" ];
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

  systemd.user.services.bt-idle-poweroff = lib.mkIf (!isDarwin && hasBluetooth) {
    Unit = {
      Description = "Power off Bluetooth after 10 minutes with nothing connected";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "bt-idle-poweroff" ''
        BTCTL="${pkgs.bluez}/bin/bluetoothctl"
        STAMP="$XDG_RUNTIME_DIR/bt-last-connected"

        if ! "$BTCTL" show | ${pkgs.gnugrep}/bin/grep -q "Powered: yes"; then
          exit 0
        fi

        if [ -n "$("$BTCTL" devices Connected)" ]; then
          ${pkgs.coreutils}/bin/touch "$STAMP"
          exit 0
        fi

        if [ ! -e "$STAMP" ]; then
          ${pkgs.coreutils}/bin/touch "$STAMP"
          exit 0
        fi

        if [ -n "$(${pkgs.findutils}/bin/find "$STAMP" -mmin +10)" ]; then
          "$BTCTL" power off
          ${pkgs.coreutils}/bin/rm -f "$STAMP"
        fi
      ''}";
    };
  };

  systemd.user.timers.bt-idle-poweroff = lib.mkIf (!isDarwin && hasBluetooth) {
    Unit = {
      Description = "Periodic Bluetooth idle check";
    };
    Timer = {
      OnStartupSec = "2min";
      OnUnitActiveSec = "1min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
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
