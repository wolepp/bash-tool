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

die() {
    local error=${1:-"undefined error"}
    echo "$0: ${BASH_LINEO[0]} $error"
}
