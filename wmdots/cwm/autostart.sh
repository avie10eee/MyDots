#!/bin/bash

function run {
 if ! pgrep $1 ;
  then
    $@&
  fi
}

#run polybar
sh ~/.config/polybar/launch.sh &

run "dex $HOME/.config/autostart/arcolinux-welcome-app.desktop"
#run "xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal"
#run "xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off"
#run xrandr --output eDP-1 --primary --mode 1368x768 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off
#run xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#run xrandr --output DVI-I-0 --right-of HDMI-0 --auto
#run xrandr --output DVI-1 --right-of DVI-0 --auto
#run xrandr --output DVI-D-1 --right-of DVI-I-1 --auto
#run xrandr --output HDMI2 --right-of HDMI1 --auto

nm-applet &
pamac-tray &
variety &
xfce4-power-manager &
blueberry-tray &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
picom -b  --config ~/.config/cwm/picom.conf &
numlockx on &
volumeicon &
sxhkd -c ~/.config/cwm/sxhkd/sxhkdrc &
conky -c $HOME/.config/cwm/system-overview &
feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &
# insync start &
# spotify &
# discord &
# telegram-desktop &

sh ~/.config/cwm/scripts/check-polybar.sh &