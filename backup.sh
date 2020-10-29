#!/usr/bin/env bash
# Wojciech Lepich

dir=$1
if [ $# -eq 2 ]; then
    ui=true
fi
source $dir/ui.sh
source $dir/utils.sh

folderToBackup=$HOME
archiveName="home_$(basename $HOME)_$(date +%Y%m%d-%H%M%S)"
archivePath=$HOME

show_backup_menu() {
    printcenter "Backup menu"
    echo "Folder do zbackupowania: $(textcolor green)$folderToBackup"
    resetstyle
    echo "Docelowa nazwa archiwum: $(textcolor green)$archiveName.tar.gz"
    resetstyle
    echo "Miejsce zapisu:          $(textcolor green)$archivePath"
    resetstyle
    echo
    echo "1. Utwórz kopię zapasową"
    echo "2. Utwórz kopię zapasową (aktualizuj datę i czas)"
    echo "-----------------------"
    echo "3. Zmień nazwę archiwum"
    echo "4. Zmień miejsce zapisu"
    echo "-----------------------"
    echo "0. Powrót"
}

read_options() {
    local choice
    read -rp "Enter choice [a-z] " choice
    case $choice in
    1) make_backup ;;
    2) make_backup_update_time ;;
    3) change_archive_name ;;
    4) change_save_path ;;
    0) exit 0 ;;

    esac
}

# ============================== Main Loop
if [ "$ui" == true ]; then
    tput clear
    tput rc
    while true; do
        tput reset
        show_backup_menu
        read_options
    done
else
    echo "Not ui. Backup do $archivePath/$archiveName.tar.gz" && sleep 2
fi
