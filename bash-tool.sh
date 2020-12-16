#!/usr/bin/env bash
# Wojciech Lepich

Help() {
    echo "Program bash-tool"
    echo
    echo "Program do zarządzania systemem"
    echo "Tworzy kopie zapasowe i przywraca"
    echo "Pokazuje logi systemowe (jeszcze nie)"
    echo "Pokazuje procesy (jeszcze nie)"
}

while getopts ":h" option; do
    case $option in
        h)
            Help
            exit 0
            ;;
    esac
done

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$dir/ui.sh"
source "$dir/utils.sh"

backup() {
    run backup.sh $dir
}

restore() {
    run restore.sh $dir
}

diskHealth() {
    run disk-health.sh $dir
}

systemLogs() {
    run system-logs.sh $dir
}

showProcesses() {
    echo "Tylko ten $0" && sleep 1
}

showDir() {
    echo $dir && sleep 2
    echo "$dir/ui.sh" && sleep 2
    pause
}

unknownOption() {
    tput setaf 1
    echo "Unknown option..." && sleep 2
    tput reset
}

read_options() {
    local choice
    read -rp "Wybierz program [1-4]: " choice
    case $choice in
    dir) showDir ;;
    1) backup ;;
    2) restore ;;
    3) diskHealth ;;
    4) systemLogs ;;
    0) exit 0 ;;
    esac
}

show_main_menu() {
    clear
    thin_divider
    printcenter "MENU GŁÓWNE"
    printcenter "Witaj w programie bash-tool." 2
    echo "Wybierz program"
    echo "   1. backup"
    echo "   2. przywracanie"
    echo "   3. disk health"
    echo "   4. logi systemowe"
    echo "   0. wyjście"
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
