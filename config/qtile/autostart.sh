#!/bin/bash
# ~/.config/qtile/autostart.sh
# Qtile autostart script for Wayland dual monitor setup

# Wait a moment for the desktop to settle
sleep 2

# Set up dual monitor configuration for Wayland
# Based on your gnome-randr output:
# HDMI-1 (Acer VG240Y) - Primary at 0,0 (left)
# DP-2 (AOC 2460) - Secondary at 1920,0 (right)
echo "Configuring monitors..." >> /tmp/qtile-autostart.log
wlr-randr --output HDMI-1 --mode 1920x1080 --pos 0,0 --output DP-2 --mode 1920x1080 --pos 1920,0

# Set wallpaper for Wayland
swaybg -i ~/Pictures/wallpaper.jpg -m fill &

# Wayland compositor is handled by Qtile itself, no need for picom

# Start authentication agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Start notification daemon
dunst &

# Start network manager applet
nm-applet &

# Start bluetooth manager
blueman-applet &

# Start audio control (PulseAudio)
pulseaudio --start

# Start clipboard manager (wl-clipboard with clipman for Wayland)
wl-paste -t text --watch clipman store &

gammastep -t 4500 &

# Auto-mount removable drives
udiskie --tray &

# Start applications
# You can uncomment these if you want them to start automatically
# firefox &
# spotify &
# discord &

echo "Qtile autostart script completed"
