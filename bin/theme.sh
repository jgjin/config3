#!/usr/bin/sh

killall lemonbar
$HOME/bin/bar-night.sh | lemonbar -f "Source Code Pro-24" -p &
xrdb $HOME/.Xresources
feh --bg-fill $HOME/pics/wallpaper-night.jpg
