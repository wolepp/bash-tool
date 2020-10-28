#!/usr/bin/env bash
# Wojciech Lepich

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$dir/ui.sh" 

pause() {
    read -rp "Press [Enter] key to continue..."
}

die() { # funkcja do wyjątków
    local error=${1:-"Undefined error"}
    echo "$0: ${BASH_LINENO[0]} $error"
}

one() {
    echo "one() called"
    die
    pause
}

backup() {
    echo "backupowanie" && sleep 1
    echo "skończone"
    pause
}

restore() {
    echo "Restoring" && sleep 1
}

diskHealth() {
    echo "Wszystko zdrowe" && sleep 1
}

systemLogs() {
    echo "Log 1" && sleep 1
}

showProcesses() {
    echo "Tylko ten $0" && sleep 1
}

showDir() {
    echo $dir && sleep 2
}

read_options() {
    local choice
    read -rp "Enter choice [1-5] " choice
    case $choice in
    dir) showDir ;;
    1) backup ;;
    2) restore ;;
    3) diskHealth ;;
    4) systemLogs ;;
    5) showProcesses ;;
    6) exit 0 ;;
    *)
        tput setaf 1
        echo "Unknown option..." && sleep 2
        tput reset
        ;;
    esac
}

# =========== MAIN LOOP
# clear
# tput cup $((LINES / 2)) $((COLUMNS / 2 - 9))
# tput rev
# tput civis
# echo "Admin tool loading" && sleep 3
# Start cleaning up our screen...
tput norm
tput clear
tput sgr0
tput rc
while true; do
    tput reset
    show_main_menu
    read_options
done
