#!/usr/bin/env bash
# Wojciech Lepich

RED='\033[0;41;30m'
STD='\033[0;0;39m'

pause() {
    read -rp "Press [Enter] key to continue..."
}

one() {
    echo "one() called"
    pause
}

two() {
    echo "two() called"
    pause
}

show_menu() {
    clear
    echo "-----------------"
    echo "   MENU GŁÓWNE   "
    echo "-----------------"
    echo "1. Set terminal"
    echo "2. Reset terminal"
    echo "3. Exit"
}

read_options() {
    local choice
    read -rp "Enter choice [1-3] " choice
    case $choice in
    1) one ;;
    2) two ;;
    3) exit 0 ;;
    *) echo "${RED}Error...${STD}" && sleep 2 ;;
    esac
}

while true; do
    show_menu
    read_options
done
