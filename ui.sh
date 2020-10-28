#!/usr/bin/env bash
# Wojciech Lepich

width=$(tput cols)
height=$(tput lines)

redraw() {
    width=$(tput cols)
    height=$(tput lines)
}
trap redraw WINCH

resetstyle() {
    tput sgr0
}

textcolor() {
    (($# == 0)) && return
    case "$1" in
    0|black)   tput setaf 0 ;;
    1|red)     tput setaf 1 ;;
    2|green)   tput setaf 2 ;;
    3|yellow)  tput setaf 3 ;;
    4|blue)    tput setaf 4 ;;
    5|magenta) tput setaf 5 ;;
    6|cyan)    tput setaf 6 ;;
    7|white)   tput setaf 7 ;;
    esac
}

show_main_menu() {
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

