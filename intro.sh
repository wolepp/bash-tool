#!/usr/bin/env bash
# Wojciech Lepich

COLUMNS=$(tput cols)

napis[0]=" _               _           _              _ "
napis[1]="| |__   __ _ ___| |__       | |_ ___   ___ | |"
napis[2]="| '_ \ / _\` / __| '_ \ _____| __/ _ \ / _ \| |"
napis[3]="| |_) | (_| \__ \ | | |_____| || (_) | (_) | |"
napis[4]="|_.__/ \__,_|___/_| |_|      \__\___/ \___/|_|"

if [[ $COLUMNS -lt ${#napis[4]} ]]; then
    echo "Zbyt wąsko"
    exit 0
fi

real_offset_x=0
real_offset_y=0

draw_char() {
    v_coord_x=$1
    v_coord_y=$2

    tput cup $((real_offset_y + v_coord_y)) $((real_offset_x + v_coord_x))

    printf %c "${napis[v_coord_y]:v_coord_x}"
}

trap 'exit 1' INT TERM
trap 'tput clear; tput cnorm; clear' EXIT

tput civis
clear

for ((c = 1; c <= 7; c++)); do
    tput setaf "$c"
    for ((x = 0; x < ${#napis[0]}; x++)); do
        for ((y = 0; y <= 4; y++)); do
            draw_char "$x" "$y"
        done
    done
done
