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

printcenter() {
    local len=${#1}
    local line=${2:-0}
    tput cup "$2" $(((width - len) / 2))
    echo "$1"
}

textcolor() {
    (($# == 0)) && return
    case "$1" in
    0 | black) tput setaf 0 ;;
    1 | red) tput setaf 1 ;;
    2 | green) tput setaf 2 ;;
    3 | yellow) tput setaf 3 ;;
    4 | blue) tput setaf 4 ;;
    5 | magenta) tput setaf 5 ;;
    6 | cyan) tput setaf 6 ;;
    7 | white) tput setaf 7 ;;
    esac
}

textreverse() {
    tput rev
}
