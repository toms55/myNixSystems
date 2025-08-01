from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import subprocess
import os

mod = "mod4"
terminal = "st" 

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "j", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "k", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "i", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "j", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "i", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "j", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "k", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "i", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key([mod], "m", lazy.window.toggle_minimize(), desc="minimise focused window"),
    Key([mod], "u", lazy.function(lambda qtile: [
        w.toggle_minimize() for w in qtile.current_group.windows if w.minimized
    ]), desc="Unminimise all windows"),

    Key([mod], "period", lazy.next_screen(), desc="Focus next monitor"),
    Key([mod], "comma", lazy.prev_screen(), desc="Focus previous monitor"),

    Key([mod, "shift"], "period", lazy.window.toscreen(1), desc="Move window to monitor 1"),
    Key([mod, "shift"], "comma", lazy.window.toscreen(0), desc="Move window to monitor 0"),

    # volume    
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 4")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 4")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Previous track"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Next track"),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Play/Pause"),

    Key([mod], "d", lazy.spawn("wofi --show drun"), desc="Launch wofi"),
    Key([mod], "f", lazy.spawn("firefox"), desc="Launch Firefox"),
    Key([mod], "s", lazy.spawn("spotify"), desc="Launch Spotify"),
    
    #screenshot
    Key([], "Print", lazy.spawn("sh -c 'grim -g \"$(slurp)\" - | wl-copy'"), desc="Copy a screenshot of a selected area to the clipboard"),

    Key([mod], "Print", lazy.spawn("sh -c 'grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot_$(date +%s).png'"), desc="Take a screenshot of a selected area"),

    Key(["shift"], "Print", 
    lazy.spawn("grim -g \"$(slurp)\" - | wl-copy"), 
    desc="Copy screenshot to clipboard"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod, "control"],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
# Wayland-safe VT switching
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(
                func=lambda: __import__("libqtile").qtile.core.name == "wayland"
            ),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_theme = {
    "border_width": 3,
    "margin": 10,
    "border_focus": "#171515", 
    "border_normal": "#1a1b26",
}

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()


# Tokyo Night colors
tokyo_colors = {
    "bg": "#1a1b26",
    "fg": "#c0caf5",
    "blue": "#7aa2f7",
    "green": "#9ece6a",
    "red": "#f7768e",
    "yellow": "#e0af68",
    "purple": "#bb9af7",
    "grey": "#565f89",
}

def create_bar(is_primary):
    
    # def get_weather():
    #     try:
    #         # Run curl with a 5-second timeout
    #         return subprocess.check_output(
    #             ["curl", "-s", "wttr.in/Sydney?format=1"],
    #             timeout=5,
    #             text=True
    #         ).strip()
    #     except (subprocess.TimeoutExpired, subprocess.CalledProcessError):
    #         # If it fails or times out, return a default string
    #         return " Weather N/A"
    #
    widgets = []

    # if not is_primary:
    #     widgets.extend([
    #         widget.GenPollText(
    #             update_interval=1800,  # every 30 minutes
    #             func=get_weather,
    #             foreground=tokyo_colors["blue"],
    #             background=tokyo_colors["bg"],
    #             padding=6
    #         ),
    #     ])


    if is_primary:
        widgets.extend([
            widget.GroupBox(
                font="JetBrainsMono Nerd Font",
                fontsize=12,
                margin_y=3,
                margin_x=6,
                padding_y=5,
                padding_x=8,
                borderwidth=2,
                active=tokyo_colors["fg"],
                inactive=tokyo_colors["grey"],
                rounded=False,
                highlight_method="line",
                this_current_screen_border=tokyo_colors["blue"],
                this_screen_border=tokyo_colors["purple"],
                other_current_screen_border=tokyo_colors["grey"],
                other_screen_border=tokyo_colors["grey"],
                disable_drag=True,
                background=tokyo_colors["bg"],
                hide_unused=True
            ),
        ])

    widgets.extend([
        widget.Prompt(
            font="JetBrainsMono Nerd Font",
            foreground=tokyo_colors["fg"],
            background=tokyo_colors["bg"],
        ),
        widget.WindowName(
            font="JetBrainsMono Nerd Font",
            foreground=tokyo_colors["fg"],
            background=tokyo_colors["bg"],
            format="{name}",
        ),
        widget.Chord(
            chords_colors={
                "launch": (tokyo_colors["red"], tokyo_colors["fg"]),
            },
            name_transform=lambda name: name.upper(),
            foreground=tokyo_colors["fg"],
            background=tokyo_colors["bg"],
        ),
    ])

    if not is_primary:
        widgets.extend([
            widget.CPU(
                format='{load_percent}%',
                foreground=tokyo_colors["green"],
                background=tokyo_colors["bg"],
                padding=6
            ),
            widget.Memory(
                format='{MemUsed:.0f}M',
                foreground=tokyo_colors["yellow"],
                background=tokyo_colors["bg"],
                padding=6
            ),
        ])

    widgets.extend([
        widget.Clock(
            format="⏱︎  %a %b %d %I:%M %p",
            foreground=tokyo_colors["purple"],
            background=tokyo_colors["bg"],
            padding=6
        ),
        widget.QuickExit(
            default_text='╰┈➤EXIT➡ ',
            countdown_format='[{}]',
            foreground=tokyo_colors["red"],
            background=tokyo_colors["bg"],
        ),
    ])

    return bar.Bar(
        widgets,
        24,
        background=tokyo_colors["bg"],
        margin=[7, 10, 0, 10],
    )



screens = [
    Screen(
        top=create_bar(is_primary=True),
    ),
    Screen(
        top=create_bar(is_primary=False),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

@hook.subscribe.startup_once
def autostart():
    wallpaper_path = '/home/tom/mySystem/config/wallpaper.jpg'
    os.path.exists(wallpaper_path) and subprocess.Popen(['swaybg', '-i', wallpaper_path])

def assign_groups_to_screens():
    qtile.screens[0].set_group(qtile.groups_map["1"])
    qtile.screens[1].set_group(qtile.groups_map["2"])


auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = "adwaita"
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
