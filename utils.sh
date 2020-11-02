#!/usr/bin/env bash
# Wojciech Lepich

run() {
    script=$1
    shift
    /usr/bin/env bash $dir/$script "$@"
}

pause() {
    read -rp "Press [Enter] key to continue..."
}

error() {
    local e=${1:-"undefined error"}
    echo "$0: $e"
    pause
}
