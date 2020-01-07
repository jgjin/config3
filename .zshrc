# Add completions
fpath=($HOME/.config/zsh/completions $fpath)

# Completion and initialization
zstyle ':completion:*' completer _expand _complete _ignored _match
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle :compinstall filename '/home/banana/.zshrc'

autoload -Uz compinit
compinit

# zsh variables (other variables in .profile)
CUSTOM_RM_THRESHOLD=5
HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=10000
HISTORY_IGNORE="(cd*|ls*|view*|man *|type *|exit)"
PROMPT='%F{068}%n%f%F{029}@%f%F{134}%m%f %F{029}%~%f %F{068}%#%f '
setopt appendhistory autocd extendedglob HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS # NO_BEEP
bindkey -v

# Ignore duplicates when going back in history
# https://github.com/zsh-users/zsh-history-substring-search/issues/19
if [[ -o HIST_FIND_NO_DUPS ]]; then
    local -A unique_matches
    for n in $_history_substring_search_matches; do
        unique_matches[${history[$n]}]="$n"
    done
    _history_substring_search_matches=(${(@no)unique_matches})
fi
# Support history-based cd
. /usr/share/z/z.sh

# avahi-resolve common names
a_resolve() {
    if [[ "$1" = 'a' ]]; then
        avahi-resolve-host-name avocado.local
    else
        if [[ "$1" = 'b' ]]; then
            avahi-resolve-host-name banana.local
        else
            avahi-resolve-host-name $1.local
        fi
    fi
}

# bspc query hidden in desktop $1
bspc_hidden() {
    bspc query -N -n .hidden -d $1
}

# toggle hidden flag on node $1
bspc_toggle() {
    bspc node $1 --flag hidden
}

# cd then ls to directory
cd_ls() {
    chdir $@
    custom_ls
}

# connect to wifi with report
connect() {
    rfkill | grep "wlan.*unblocked unblocked" &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Unblocking wifi card"
        sudo rfkill unblock all
    fi

    sudo netctl stop-all
    echo "Starting profile $1"
    sudo netctl start $1 || return 2
    echo "Waiting for profile $1 to go online"
    sudo netctl wait-online $1
    FALLBACK_NET=$(sudo netctl list | ag "\*" | cut -d' ' -f2)

    # sleep 2
    # echo "Attempting to connect to routable IP"
    # ping -c 1 8.8.8.8 -W 15 # &> /dev/null
    # if [ "$?" -eq 0 ]; then
    #   echo "Connecting to VPN"
    #   gpg --decrypt $HOME/.config/vpn/credentials.gpg | sudo openconnect $VPN
    #   return 0
    # fi
    # echo "Could not connect to routable IP, so not connecting to VPN"
    # return 1
}

# count files and directories in current directory
count() {
    NUM_FILES=`find $PWD -maxdepth 1 -type f | wc -l`
    NUM_DIRECTORIES=`find $PWD -maxdepth 1 -type d | wc -l`
    echo $NUM_FILES "files," $NUM_DIRECTORIES "directories"
}

# https://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal
# Start countdown from $1 seconds
countdown() {
    date1=$((`date +%s` + $1));
    while [ "$date1" -ge `date +%s` ]; do
        echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
        sleep 0.1
    done
}

# cd if directory in current directory, otherwise move to directory based on history
custom_cd() {
    if [[ "$#" -eq 0 ]]; then
        chdir $HOME
    else
        if [[ -d "$1" ]] || [[ "$1" = '-' ]]; then
            chdir $1
        else
            z $@ && echo $@ "found using z" || echo $@ "not found under either cd and z"
        fi
    fi
}

# ls with default preferred args into less if necessary
custom_ls() {
    TPUT_COLS=`tput cols`
    if /bin/ls -C --width $TPUT_COLS $@ > /tmp/ls.txt; then
        LS_LINES=`wc -l < /tmp/ls.txt`
        /usr/bin/rm /tmp/ls.txt
        TPUT_LINES=`tput lines`
        if [ "$LS_LINES" -gt "$TPUT_LINES" ]; then
            /bin/ls --almost-all --classify --color=always -C --width $TPUT_COLS $@ | less -R
        else
            /bin/ls --almost-all --classify --color=always -C --width $TPUT_COLS $@
        fi
    fi
}

# Add any special behavior for mv
custom_mv() {
    # if [ "$PWD" = '/home/banana/music' ]; then
    #   echo "Please use movemusic"
    # else
    /usr/bin/mv -i $@
    # fi
}

# TODO: fix prompt not always appearing
# Warn if files more than CUSTOM_RM_THRESHOLD
custom_rm() {
    # if [ "$PWD" = '/home/banana/music' ]; then
    #   echo "Please use removemusic"
    # else
    CUSTOM_RM_NUM=0
    for arg in "$@"; do
        if [ $arg[0,1] != '-' ]; then
            if [ -d "$arg" ]; then
                find $arg -type f | sort > /tmp/custom_rm_$CUSTOM_RM_NUM.txt
            else
                echo $arg > /tmp/custom_rm_$CUSTOM_RM_NUM.txt
            fi
            CUSTOM_RM_NUM=$(($CUSTOM_RM_NUM + 1))
        fi
    done
    if [ "$CUSTOM_RM_NUM" -gt 0 ]; then
        cat /tmp/custom_rm_*.txt > /tmp/custom_rm.txt
        /usr/bin/rm /tmp/custom_rm_*.txt
        CUSTOM_RM_FILES=`wc -l < /tmp/custom_rm.txt`
    else
        CUSTOM_RM_FILES=-1
    fi
    if [ "$CUSTOM_RM_FILES" -gt "$CUSTOM_RM_THRESHOLD" ]; then
        echo "rm $CUSTOM_RM_FILES files? "
        TPUT_LINES=`tput lines`
        if [ "$CUSTOM_RM_FILES" -gt "$TPUT_LINES" ]; then
            cat /tmp/custom_rm.txt | less
        else
            cat /tmp/custom_rm.txt
        fi
        /usr/bin/rm /tmp/custom_rm.txt
        local CUSTOM_RM_RESPONSE
        vared CUSTOM_RM_RESPONSE
        if [ "$CUSTOM_RM_RESPONSE" = 'y' ]; then
            /usr/bin/rm $@
        else
            echo "Aborted"
        fi
    else
        /usr/bin/rm -i $@
    fi
    # fi
}

# Report bspwm desktop layouts for all desktops
desktop_layouts() {
    for id in $(bspc query -D); do
        DESKTOP_JSON=`bspc query -d $id -T`
        DESKTOP_NAME=`echo $DESKTOP_JSON | jshon -e name`
        DESKTOP_LAYOUT=`echo $DESKTOP_JSON | jshon -e layout`
        if [ "$DESKTOP_LAYOUT" != "\"tiled\"" ]; then
            echo $DESKTOP_NAME layout: $DESKTOP_LAYOUT
        fi
    done
}

# Execute du sorted by size
disk_usage() {
    du -hd1 $@ | sort -h
}

# Execute as emacsclient and background process
emacsclient_background() {
    emacsclient -n -e "(if (> (length (frame-list)) 1) 't)" 2> /dev/null | grep t &> /dev/null

    if [ "$?" -eq "1" ]; then
        emacsclient -a '' -nqc "$@" &> /dev/null
    else
        emacsclient -nq "$@" &> /dev/null
    fi
}

feh() {
    xdo lower -a "bar"
    /usr/bin/feh --fullscreen --auto-zoom --image-bg black --quiet --fontpath /usr/share/fonts/TTF/ --menu-font "Roboto-Regular/24" "$@"
    xdo raise -a "bar"
}

# Find all images matching argument expression
# find_img() {
#     find $@ -type f > /tmp/img.txt
# }

# Find all images with one or more provided words in name
# find_img_set() {
#     FIND_IMG_SET_NUM=0
#     for word in "$@"; do
#   find -type f -wholename "*$word*" ! -wholename "*old*" ! -wholename "*\\.gif" > /tmp/find_img_$FIND_IMG_SET_NUM.txt
#   FIND_IMG_SET_NUM=$(($FIND_IMG_SET_NUM + 1))
#     done
#     cat /tmp/find_img_*.txt > /tmp/img.txt
#     rm -f /tmp/find_img_*.txt
# }

# Find all images matching argument expression and view in sorted order
# find_view_sort() {
#     find_img $@
#     view -f /tmp/img.txt --sort filename &
# }

# Firefox for every line of file $1
firefox_tabs() {
    while IFS= read -r var
    do
        firefox "${@:2}" "$var"
    done < "$1"
}

# Git commit files with changes
git_commit_diff() {
    COMMIT_FILES=$(git diff --name-only HEAD | tr '\n' ' ')
    eval "git commit $COMMIT_FILES"
}

# Diff $1 commits behind
git_diff() {
    git diff HEAD~$1
}

# Merge $1 commits behind
git_merge() {
    git rebase -i HEAD~$1
}

heartbeat_reconnect() {
    sudo echo &> /dev/null
    while :
    do
        ping -c 1 -w 12 8.8.8.8 &> /dev/null
        if [[ $? -ne 0 ]]; then
            echo "Packet timed out, reconnecting"
            reconnect
            if [[ $? -ne 0 ]]; then
                echo "Falling back to connecting to network $FALLBACK_NET"
                connect $FALLBACK_NET
            fi
        else
            # echo "Packet received, sleeping"
            sleep 3
        fi
    done
}

# # mv album and run speed_up_albums
# move_music() {
#     mv $@
#     cd $HOME/music
#     speed_up_albums $HOME/music 1.40 $HOME/music/sped-up
#     cd -
# }

# Move then change to that directory
mv_cd() {
    custom_mv $@
    chdir "${@: -1}"
    ls
}

# Search pacman and print pkgfile suggestion if fails
pac_search() {
    pacman -Ss $@ || echo "No package found, maybe use pkgfile?"
}

# # Play audio at 1.40x speed
# play() {
#     if [ "$1" -eq "$1" ] 2>/dev/null; then
#   amixer -q sset Master $1%
#   ARGS=${@:2}
#     else
#   ARGS=$@
#     fi
#     mpv --speed=1.40 --hwdec=auto --gapless-audio=yes --input-ipc-server=/tmp/mpvsocket --no-audio-display $ARGS
# }

# # Perform command ${@:2} on arguments matching regex $1
# rec_regex() {
#     COMMAND=${@:2}
#     ARGS=$(ag --smart-case -g $1 | sed 's/ /\\ /g' | tr '\n' ' ')
#     eval "$COMMAND $ARGS"
# }

# Reconnect to current wi-fi network
reconnect() {
    CUR_NET=$(sudo netctl list | ag "\*" | cut -d' ' -f2)
    if [[ -z "$CUR_NET" ]]; then
        echo "Not connected"
        return 1
    else
        echo "Disconnecting from $CUR_NET"
        sudo netctl stop-all
        connect $CUR_NET
    fi
    return 0
}

# # rm album and rm sped-up/album
# remove_music() {
#     for album in "$@"; do
#   read -k "rm -rf $HOME/music{,/sped-up}/$album? " REMOVE_MUSIC_RESPONSE
#   if [[ "$REMOVE_MUSIC_RESPONSE" -eq 'y' ]]; then
#       rm -rf $HOME/music{,/sped-up}/$album
#   fi
#     done
# }

# Set address of Volumio
set_volumio() {
    echo 192.168.1.$1 > /tmp/volumio
}

# # Speed up audio files in $1 by $2 into $3
# speed_up_album() {
#     if [ ! -d "$3" ]; then
#   mkdir -p $3
#     fi
#     for INODE in $1/*; do
#   BASE_NAME=$(basename $INODE)
#   if [ -d "$INODE" ]; then
#       speed_up_album $INODE $2 $3/$BASE_NAME
#   else
#       echo $3/$BASE_NAME
#       # sox $INODE $3/$BASE_NAME -V tempo -m $2 2> /dev/null
#       ffmpeg -i $INODE -filter:a "atempo=$2" $3/$BASE_NAME 2> /dev/null
#   fi
#     done
# }

# # Speed up all files in directories in $1 by $2 into $3
# speed_up_albums() {
#     for INODE in $1/*; do
#   if [ ! -d "$INODE" ]; then
#       echo $INODE "is file, skipping"
#   else
#       BASE_NAME=$(basename $INODE)
#       if [ -d "$3/$BASE_NAME" ]; then
#     echo $3/$BASE_NAME "already exists, skipping"
#       else
#     if [ "$BASE_NAME" != "$3" -a "$BASE_NAME" != "tracklists" -a "$BASE_NAME" != "metadata" -a "$BASE_NAME" != "annotate" ]; then
#         speed_up_album $INODE $2 $3/$BASE_NAME
#     fi
#       fi
#   fi
#     done
#     echo "Filtered diff results:"
#     diff -qr $1 $3 | ag "Only in" | ag "Only in $1: $3" --invert-match
# }

# # SSH into raspberry pi
# ssh_rpi() {
#     if [[ "$#" -eq 0 ]]; then
#   ssh volumio@192.168.211.1
#     else
#   ssh volumio@$1
#     fi
# }

# Start stopwatch with hours, minutes, and seconds
stopwatch() {
    date1=`date +%s`;
    while true; do
        echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
        sleep 0.1
    done
}

# Update essential configuration at $HOME
update_config() {
    # /usr/bin/ls $HOME/music > $HOME/album_list.txt
    pacman -Qqe > $HOME/.config/package_list.txt
    /usr/bin/ls $HOME/aur > $HOME/.config/aur_list.txt
    chdir ~/.config/
    git_commit_diff
    chdir -/.config/
}

# # Update music in Raspberry Pi
# update_music() {
#     if [[ "$#" -eq 0 ]]; then
#   # for phone SD card
#   # sudo rsync -a -huv --delete --info=progress2 $HOME/music/ --exclude "annotate" --exclude "metadata" --exclude "sped-up" --exclude "tracklists" /mnt/sdcard/music/
#   # for volumio SD card
#   sudo rsync -a -huv --delete --info=progress2 $HOME/music/sped-up/ /mnt/sdcard/dyn/data/INTERNAL
#     else
#   rsync -a -huv --delete --info=progress2 $HOME/music/sped-up/ volumio@$1:/mnt/INTERNAL
#     fi
# }

# View pictures with viewer.py
view() {
    xdo lower -a "bar"
    sudo $HOME/pics/.old/viewer.py $@
    xdo raise -a "bar"
}

# View pictures sorted by name in fullscreen without bar
view_sort() {
    xdo lower -a "bar"
    feh --fullscreen --auto-zoom --image-bg black --quiet --fontpath /usr/share/fonts/TTF/ --menu-font "Roboto-Regular/24" --sort mtime $@
    if ! pidof "feh" > /dev/null; then
        xdo raise -a "bar"
    fi
}

# View images with one or more provided words in name
# view_set() {
#     find_img_set $@
#     view -f /tmp/img.txt --sort filename
# }

# View all pictures in directory
# view_all() {
#     find_img .
#     view -f /tmp/img.txt $@
# }

# Diable touchscreen
x_disable() {
    xinput disable $(xinput list | ag "ELAN25B5:00" | cut -d'=' -f2 | cut -f1)
}

# # Other configurations
# source $HOME/.config/postgres/config.sh
source $HOME/.config/vpn/config.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source $HOME/.config/zsh/keybindings

# Aliases
source $HOME/.config/.aliases.sh

# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/banana/dls/google-cloud-sdk/path.zsh.inc' ]; then . '/home/banana/dls/google-cloud-sdk/path.zsh.inc'; fi

# # The next line enables shell command completion for gcloud.
# if [ -f '/home/banana/dls/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/banana/dls/google-cloud-sdk/completion.zsh.inc'; fi
