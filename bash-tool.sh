#!/usr/bin/env bash
# Wojciech Lepich


COLUMNS=$(tput cols)
LINES=$(tput lines)

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

two() {
    echo "two() called"
    die "File not found"
    pause
}

backup() {
    echo "Tworzenie backupu folderu ${HOME}" && sleep 2
    tput setaf 
    echo "Ukończono"
    tput reset
}

restore() {
    echo "Restoring"
}

diskHealth() {
    echo "Wszystko zdrowe"
}

systemLogs() {
    echo "Log 1"
    echo "Log 2"
    echo "Log 3"
}

showProcesses() {
    echo "Tylko ten $0"
}

show_menu() {
    clear
    echo "-----------------"
    echo "   MENU GŁÓWNE   "
    echo "-----------------"
    echo "1. backup"
    echo "2. przywracanie"
    echo "3. disk health"
    echo "4. logi systemowe"
    echo "5. procesy"
    echo "6. wyjście"
}

read_options() {
    local choice
    read -rp "Enter choice [1-5] " choice
    case $choice in
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
clear
tput cup $((LINES / 2)) $((COLUMNS / 2 - 9))
tput rev
tput civis
echo "Admin tool loading" && sleep 3
# Start cleaning up our screen...
tput norm
tput clear
tput sgr0
tput rc
while true; do
    tput reset
    show_menu
    read_options
done
