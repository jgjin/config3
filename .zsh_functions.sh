# Connect to wifi with feedback
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
}

# Count files and directories in current directory
count() {
    NUM_FILES=`find $PWD -maxdepth 1 -type f | wc -l`
    NUM_DIRECTORIES=`find $PWD -maxdepth 1 -type d | wc -l`
    echo $NUM_FILES "files," $NUM_DIRECTORIES "directories"
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
}

# Firefox for every line of file $1
firefox_tabs() {
    while IFS= read -r var
    do
        firefox "${@:2}" "$var"
    done < "$1"
}

# Reconnect to current network
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
