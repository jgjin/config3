alias disconnect="sudo netctl stop-all"
alias emc="emacsclient_background"
alias grep="rg"
alias lowerbar="xdo lower -a bar"
alias ls="ls --almost-all"
alias mpv="lowerbar; mpv --input-ipc-server=/tmp/mpvsocket --fs --alpha=blend"
alias pacdl="sudo pacman -S"
alias pacinstall="sudo pacman -U"
alias pacrecent="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n"
alias pacrm="sudo pacman -Rs"
alias pacsearch="pacman -Ss"
alias pacupdate="sudo pacman -Syy"
alias pacupgrade="sudo pacman -Su"
alias poweroff="systemctl hibernate"
alias raisebar="xdo raise -a bar"
alias rename="rename -i"
alias rg="rg --smart-case -uu"
alias rgf="rg --files | rg"
alias viewsort="feh --fullscreen --auto-zoom --image-bg black --quiet --fontpath /usr/share/fonts/TTF/ --menu-font \"Roboto-Regular/24\" --sort mtime"
