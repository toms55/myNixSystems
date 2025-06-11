# Enhanced Qtile configuration for dual monitors with beautiful styling

import os
import subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# Color scheme - Modern Tokyo Night inspired theme
colors = {
    'bg': '#1a1b26',           # Dark background
    'bg_alt': '#24283b',       # Alternative background
    'fg': '#c0caf5',           # Light foreground
    'accent': '#7aa2f7',       # Blue accent
    'accent2': '#bb9af7',      # Purple accent
    'accent3': '#73daca',      # Teal accent
    'warning': '#e0af68',      # Yellow/orange
    'error': '#f7768e',        # Red/pink
    'success': '#9ece6a',      # Green
    'inactive': '#3b4261',     # Inactive/dim
    'urgent': '#ff5555',       # Urgent red
    'border_focus': '#7aa2f7', # Focused border
    'border_normal': '#414868', # Normal border
    'transparent': '#00000000', # Transparent
}

# Super key (Windows key)
mod = "mod4"
terminal = "alacritty"

# Keybindings
keys = [
    # Essential window management
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    
    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    
    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    
    # Toggle between split and unsplit sides of stack
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    
    # Toggle fullscreen
    Key([mod], "F11", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),

    # Switch monitor in focus
    Key([mod], "w", lazy.next_screen(), desc="Switch to other monitor"),
    
    # Applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "f", lazy.spawn("firefox"), desc="Launch Firefox"),
    Key([mod], "s", lazy.spawn("spotify"), desc="Launch Spotify"),
    Key([mod], "e", lazy.spawn("thunar"), desc="Launch file manager"),
    Key([mod], "c", lazy.spawn("code"), desc="Launch VS Code"),
    
    # System controls
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"), desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"), desc="Volume down"),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc="Toggle mute"),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%"), desc="Brightness up"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-"), desc="Brightness down"),
    
    # Screenshots
    Key([], "Print", lazy.spawn("grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"), desc="Screenshot"),
    Key(["shift"], "Print", lazy.spawn("grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"), desc="Screenshot area"),
    
    # Close window - NOTE: You had 'w' bound twice, I'm keeping the monitor switch
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    
    # Monitor switching
    Key([mod], "comma", lazy.to_screen(0), desc="Focus monitor 1"),
    Key([mod], "period", lazy.to_screen(1), desc="Focus monitor 2"),
    Key([mod, "shift"], "comma", lazy.window.toscreen(0), desc="Move window to monitor 1"),
    Key([mod, "shift"], "period", lazy.window.toscreen(1), desc="Move window to monitor 2"),
    
    # Restart/quit qtile
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    
    # Application launcher
    Key([mod], "r", lazy.spawn("wofi --show drun"), desc="Run launcher"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Run rofi launcher"),
]

# Groups (workspaces) with beautiful icons
group_names = [
    ("1", "󰲠"), ("2", "󰈹"), ("3", "󰨞"), 
    ("4", "󰉋"), ("5", "󰝚"), ("6", "󰊴"), 
    ("7", "󰀵"), ("8", "󰙯"), ("9", "󰓓")
]

groups = [Group(name, label=label) for name, label in group_names]

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name)),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), 
            desc="Switch to & move focused window to group {}".format(i.name)),
    ])

# Layouts with beautiful styling
layout_theme = {
    "border_width": 2,
    "border_focus": colors['border_focus'],
    "border_normal": colors['border_normal'],
    "margin": 12
}

layouts = [
    layout.Columns(
        **layout_theme,
        border_focus_stack=[colors['accent'], colors['accent2']],
        border_on_single=True,
        insert_position=1,
    ),
    layout.MonadTall(
        **layout_theme,
        single_border_width=2,
        single_margin=12,
    ),
    layout.MonadWide(
        **layout_theme,
        single_border_width=2,
        single_margin=12,
    ),
    layout.Bsp(
        **layout_theme,
        fair=False,
    ),
    layout.Max(),
    layout.Floating(**layout_theme),
]

# Widget styling
widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=14,
    padding=0,
    background=colors['transparent'],
    foreground=colors['fg']
)
extension_defaults = widget_defaults.copy()

# Beautiful powerline-style separators
def left_arrow(bg_color, fg_color):
    return widget.TextBox(
        text='',
        fontsize=26,
        padding=0,
        background=bg_color,
        foreground=fg_color
    )

def right_arrow(bg_color, fg_color):
    return widget.TextBox(
        text='',
        fontsize=26,
        padding=0,
        background=bg_color,
        foreground=fg_color
    )

# Custom separator
def separator(padding=8):
    return widget.Sep(
        linewidth=0,
        padding=padding,
        foreground=colors['transparent'],
        background=colors['transparent']
    )

# Create beautiful powerline-style status bar
def create_bar():
    return bar.Bar([
        # Left side - Groups
        widget.GroupBox(
            font="JetBrainsMono Nerd Font",
            fontsize=18,
            margin_y=6,
            margin_x=0,
            padding_y=8,
            padding_x=8,
            borderwidth=3,
            active=colors['fg'],
            inactive=colors['inactive'],
            rounded=False,
            highlight_color=colors['accent'],
            highlight_method="line",
            this_current_screen_border=colors['accent'],
            this_screen_border=colors['accent2'],
            other_current_screen_border=colors['inactive'],
            other_screen_border=colors['inactive'],
            disable_drag=True,
            background=colors['bg_alt'],
            block_highlight_text_color=colors['fg'],
        ),
        
        right_arrow(colors['transparent'], colors['bg_alt']),
        
        separator(12),
        
        # Layout indicator with background
        left_arrow(colors['accent'], colors['transparent']),
        widget.CurrentLayout(
            foreground=colors['bg'],
            background=colors['accent'],
            font="JetBrainsMono Nerd Font Bold",
            fmt="  {}  ",
            padding=0,
        ),
        right_arrow(colors['transparent'], colors['accent']),
        
        separator(12),
        
        # Window name
        widget.WindowName(
            foreground=colors['fg'],
            background=colors['transparent'],
            max_chars=60,
            font="JetBrainsMono Nerd Font Medium",
            format='{name}',
            empty_group_string='Desktop',
        ),
        
        widget.Spacer(background=colors['transparent']),
        
        # Right side - System info with powerline style
        
        # Network
        left_arrow(colors['accent3'], colors['transparent']),
        widget.Net(
            format="󰈀 {down:.0f}{down_suffix} ↓ {up:.0f}{up_suffix} ↑",
            foreground=colors['bg'],
            background=colors['accent3'],
            font="JetBrainsMono Nerd Font Bold",
            update_interval=2,
            padding=12,
        ),
        
        # CPU
        left_arrow(colors['success'], colors['accent3']),
        widget.CPU(
            format="󰍛 {load_percent}%",
            foreground=colors['bg'],
            background=colors['success'],
            font="JetBrainsMono Nerd Font Bold",
            update_interval=2,
            padding=12,
        ),
        
        # Memory
        left_arrow(colors['warning'], colors['success']),
        widget.Memory(
            format="󰘚 {MemUsed:.0f}{mm}",
            foreground=colors['bg'],
            background=colors['warning'],
            font="JetBrainsMono Nerd Font Bold",
            update_interval=2,
            measure_mem='G',
            padding=12,
        ),
        
        # Volume
        left_arrow(colors['accent2'], colors['warning']),
        widget.PulseVolume(
            fmt="󰕾 {}",
            foreground=colors['bg'],
            background=colors['accent2'],
            font="JetBrainsMono Nerd Font Bold",
            volume_app="pavucontrol",
            padding=12,
        ),
        
        # Battery (if present)
        left_arrow(colors['error'], colors['accent2']),
        widget.Battery(
            format="{char} {percent:2.0%}",
            charge_char="󰂄",
            discharge_char="󰂃",
            full_char="󰁹",
            unknown_char="󰂑",
            empty_char="󰂎",
            foreground=colors['bg'],
            background=colors['error'],
            font="JetBrainsMono Nerd Font Bold",
            low_percentage=0.2,
            low_foreground=colors['bg'],
            update_interval=10,
            padding=12,
        ),
        
        # Clock
        left_arrow(colors['accent'], colors['error']),
        widget.Clock(
            format="󰃭 %a, %b %d  󰅐 %I:%M %p",
            foreground=colors['bg'],
            background=colors['accent'],
            font="JetBrainsMono Nerd Font Bold",
            padding=12,
        ),
        
        # System tray with background
        left_arrow(colors['bg_alt'], colors['accent']),
        widget.Systray(
            background=colors['bg_alt'],
            padding=8,
            icon_size=18,
        ),
        
        # Quick exit
        widget.QuickExit(
            default_text="󰐥",
            countdown_format="[{}]",
            fontsize=18,
            foreground=colors['error'],
            background=colors['bg_alt'],
            padding=12,
        ),
        
    ], 
    36,  # Bar height - slightly taller for better appearance
    background=colors['transparent'],
    opacity=1.0,
    margin=[6, 6, 0, 6],  # top, right, bottom, left margins
    )

# Screen configuration for dual monitors
screens = [
    # Primary monitor (usually left)
    Screen(
        top=create_bar(),
        wallpaper='~/Pictures/wallpaper.jpg',
        wallpaper_mode='fill',
    ),
    # Secondary monitor (usually right)
    Screen(
        top=create_bar(),
        wallpaper='~/Pictures/wallpaper.jpg',
        wallpaper_mode='fill',
    ),
]

# Auto-detect connected monitors and adjust screens accordingly
@hook.subscribe.startup_complete
def autostart():
    # Run autostart script
    autostart_script = os.path.expanduser("~/mySystem/config/qtile/autostart.sh")
    if os.path.isfile(autostart_script):
        subprocess.run([autostart_script])

# Mouse configuration
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# Other settings
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False

# Enhanced floating layout with beautiful styling
floating_layout = layout.Floating(
    border_width=2,
    border_focus=colors['border_focus'],
    border_normal=colors['border_normal'],
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="blueman-manager"),
        Match(wm_class="nm-connection-editor"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(title="Calculator"),
        Match(wm_class="gnome-calculator"),
    ]
)

# Application rules for specific workspaces
def assign_app_to_group(client):
    """Assign applications to specific groups/workspaces"""
    wm_class = client.window.get_wm_class()
    if wm_class:
        if "firefox" in wm_class or "Firefox" in wm_class:
            client.togroup("2")
        elif "spotify" in wm_class or "Spotify" in wm_class:
            client.togroup("9")
        elif "discord" in wm_class or "Discord" in wm_class:
            client.togroup("8")
        elif "code" in wm_class or "Code" in wm_class:
            client.togroup("3")

@hook.subscribe.client_new
def assign_app_group(client):
    assign_app_to_group(client)

# System settings
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

# Wayland-specific settings
wl_input_rules = None

# For Java applications
wmname = "LG3D"
