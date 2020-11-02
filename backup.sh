#!/usr/bin/env bash
# Wojciech Lepich

dir=$1
if [ $# -eq 2 ]; then
    ui=$2
fi
source $dir/ui.sh
source $dir/utils.sh

folderToBackup=$HOME
archiveName="home_$(basename $HOME)_$(date +%Y%m%d-%H%M%S)"
archivePath="$HOME"
verbose=false

validate_path() {
    if [[ -f "$archivePath" ]]; then
        error "$archivePath jest plikiem, zmień miejsce zapisu"
        return 1
    fi
    if [[ ! -d "$archivePath" ]]; then
        error "folder $archivePath nie istnieje"
        return 2
    fi
    if [[ -f "$archivePath/$archiveName" ]]; then
        local overwrite
        read -rp "Plik $archivePath/$archiveName już istnieje, nadpisać? [t/N] " overwrite
        case $overwrite in
        t | T | y | Y) return 0 ;;
        n | N | *)     return 3 ;;
        esac
    fi
    return 0
}

testPath="$HOME/test"

make_backup() {
    validate_path
    if [[ $? -ne 0 ]]; then return 4; fi
    textcolor cyan
    echo "Tworzę kopię zapasową..."
    tar -czf
}

switch_verbose() {
    if [[ verbose ]]; then
    verbose=fals
}

show_backup_menu() {
    thin_divider
    printcenter "BACKUP"
    echo "Folder do zbackupowania: $(textcolor green)$folderToBackup"
    resetstyle
    echo "Docelowa nazwa archiwum: $(textcolor green)$archiveName.tar.gz"
    resetstyle
    echo "Miejsce zapisu:          $(textcolor green)$archivePath"
    resetstyle
    if [[ verbose ]]; then
        echo "Szczegółowe wypisywanie: $(textcolor green)tak"
    else
        echo "Szczegółowe wypisywanie: $(textcolor yellow)tak"
    fi
    resetstyle
    thick_divider
    echo "1. Utwórz kopię zapasową"
    echo "2. Utwórz kopię zapasową (aktualizuj datę i czas)"
    thin_divider
    echo "3. Zmień nazwę archiwum"
    echo "4. Zmień miejsce zapisu"
    thin_divider
    echo "5. Przestaw szczegółowe wypisywanie programu tar"
    thin_divider
    echo "0. Powrót"
    thin_divider
}

read_options() {
    local choice
    read -rp "Enter choice [a-z] " choice
    case $choice in
    1) make_backup ;;
    2) make_backup_update_time ;;
    3) change_archive_name ;;
    4) change_save_path ;;
    5) switch_verbose ;;
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