#!/usr/bin/env bash
# Wojciech Lepich

ui=true
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$dir/ui.sh" 
source "$dir/utils.sh"

backup() {
    run backup.sh $dir $ui
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
    echo "$dir/ui.sh" && sleep 2
    pause
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

show_main_menu() {
    clear
    thin_divider
    printcenter "MENU GŁÓWNE"
    echo "1. backup"
    echo "2. przywracanie"
    echo "3. disk health"
    echo "4. logi systemowe"
    echo "5. procesy"
    echo "6. wyjście"
    thin_divider
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
