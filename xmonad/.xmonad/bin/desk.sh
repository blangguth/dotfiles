#!/bin/sh
xrandr --output VGA-1 --off --output LVDS-1 --primary --mode 1366x768 --pos 2560x672 --rotate normal --output HDMI-3 --off --output HDMI-2 --off --output HDMI-1 --off --output DP-3 --off --output DP-2 --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --off

killall feh
feg --bg-style ~/pictures/debian-gray-red.jpg
