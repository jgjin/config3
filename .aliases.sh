# alias i
# alias j
# alias o
# alias q
# alias t
alias ack="rg"
alias ag="rg"
alias aresolve="a_resolve"
alias audioinfo="mediainfo"
alias bluetoothctlenable="pactl load-module module-bluetooth-policy; pactl load-module module-bluetooth-discover"
alias brightness="sudo tee /sys/class/backlight/intel_backlight/brightness <<<"
alias bspchidden="bspc_hidden"
alias bspctoggle="bspc_toggle"
alias cd="custom_cd"
alias cdls="cd_ls"
alias clear="/usr/bin/clear; echo Please use C-l"
alias cp="cp -i"
alias customcd="custom_cd"
alias desklay="desktop_layouts"
alias disconnect="sudo netctl stop-all"
alias diskusage="disk_usage"
alias emc="emacsclient_background"
alias findimg="find_img"
alias findimgset="find_img_set"
alias findviewsort="find_view_sort"
alias firefoxprivate="$HOME/bin/firefox-private.sh"
alias firefoxtabs="firefox_tabs"
alias fm="pcmanfm"
alias gitamend="git commit --amend"
alias gitcommitdiff="git_commit_diff"
alias gitdiff="git_diff"
alias gitlist="git ls-tree --full-tree -r HEAD"
alias gitmerge="git_merge"
alias gitpush="git push -u origin master"
alias grep="rg"
alias heartbeat="heartbeat_reconnect"
alias kblight="$HOME/bin/kb-light.py"
alias lemonbar="$HOME/bin/bar-day.sh | lemonbar -f \"Source Code Pro-24\" -p &; xdo lower -a bar"
alias lock="xscreensaver-command -lock"
alias lowerbar="xdo lower -a bar"
alias ls="custom_ls"
alias lsdir="find -type d -printf '%d\t%P\n' | sort -r -nk1 | cut -f2-"
alias makepkg="makepkg -Acs"
alias movemusic="move_music"
alias mpv="mpv --input-ipc-server=/tmp/mpvsocket"
alias mv="custom_mv"
alias mvcd="mv_cd"
alias network="iw dev wlp2s0 link"
alias pacdl="sudo pacman -S"
alias pacfiles="pacman -Ql"
alias pacinstall="sudo pacman -U"
alias paclist="pacman -Qqe"
alias pacrecent="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n"
alias pacrm="sudo pacman -Rs"
alias pacsearch="pac_search"
alias pacupdate="sudo pacman -Syy"
alias pacupgrade="sudo pacman -Su"
alias playh="play 24"
alias plays="play 50"
alias poweroff="systemctl hibernate"
alias psqlh="gpg --decrypt $HOME/.config/postgres/passphrase.gpg > $HOME/.pgpass; psql --host=$PGHOST --port=$PGPORT --dbname=$PGDATABASE --username=$PGUSER; cat /dev/null > $HOME/.pgpass"
alias raisebar="xdo raise -a bar"
alias recregex="rec_regex"
alias rg="rg --smart-case -uu"
alias rgf="rg --files | rg"
alias rm="custom_rm"
alias rmirrors="sudo reflector --verbose --score 20 --sort rate --save /etc/pacman.d/mirrorlist"
alias rtime="sudo tzupdate; sudo ntpdate -s time.nist.gov"
alias rxres="xrdb $HOME/.Xresources-night"
alias rzsh="source $HOME/.zshrc"
alias screens="xrandr -q | grep \"connected\""
alias setwallpaper="feh --bg-fill"
alias setvolumio="set_volumio"
alias speedupalbums="cd ~/music; speed_up_albums . 1.40 sped-up; cd -"
alias sshrpi="ssh_rpi"
alias updateconfig="update_config"
alias updatemusic="update_music"
alias videoinfo="mediainfo"
alias viewsort="view_sort"
alias volume="amixer -q sset Master"
alias volumio="set_volumio"
alias vpnactivate="sudo echo &> /dev/null; gpg --decrypt $HOME/.config/vpn/credentials.gpg | sudo openconnect $VPN"
alias vpncheck="ip tuntap list"
alias wallpaper="setwallpaper $HOME/pics/wallpaper-day.jpg"
alias whoops="bspc node $(bspc query -N -n .hidden | head -n1) --flag hidden"
alias xdisable="x_disable"
alias xmacrorec="xmacrorec2 > /tmp/xmacro"
alias ydl="youtube-dl --format bestaudio --output \"$HOME/music/%(playlist)s/%(autonumber)s %(title)s.%(ext)s\""
alias ydls="youtube-dl --format bestaudio --output \"$HOME/music/singles/%(title)s.%(ext)s\""
alias zd="z -r"