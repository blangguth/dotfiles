#!/bin/sh
# Notebook plus external monitor, which is DP2 or DP3 depending on the port.
external=$(xrandr --query | awk '/^(DP|HDMI)[0-9]+ connected/ { print $1; exit }')
[ -n "$external" ] || { echo "no external monitor connected" >&2; exit 1; }
others=$(xrandr --query | awk -v keep="$external" '/^(VGA|DP|HDMI)[0-9]/ && $1 != keep { printf "--output %s --off ", $1 }')

xrandr $others --output LVDS1 --primary --mode 1366x768 --pos 2560x672 --rotate normal --output "$external" --mode 2560x1440 --pos 0x0 --rotate normal

killall feh
feh --bg-fill ~/pictures/wallpapers/debian-gray-red.jpg
