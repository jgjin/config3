#!/usr/bin/sh

# Switch out Caps Lock for Esc
xcape -e "Alt_L=Escape"

# Start clipmenu dameon
clipmenud &

# Notification daemon
dunst &

# Start night theme
xrdb $HOME/.Xresources
feh --bg-fill $HOME/pics/wallpaper-night.jpg

# Start window compositor
picom -b --config $HOME/.config/picom.conf

# Start xscreensaver daemon
xscreensaver &

# Lock on suspend
xss-lock -- /usr/bin/xscreensaver-command -lock &

# Disable touchscreen (device-specific)
xinput disable $(xinput list | rg "ELAN" | cut -d= -f2 | cut -d'[' -f1)

# Start Redshift with geoclue2
redshift -l geoclue2 &> /dev/null &

# Start emacs
emacs --daemon

# Start keyboard shortcut manager
sxhkd &

# Start window manager
exec bspwm -c $HOME/.config/bspwm/bspwmrc
