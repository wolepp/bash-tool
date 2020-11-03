#!/usr/bin/env bash
# Wojciech Lepich

dir=$1
if [ $# -eq 2 ]; then
    ui=$2
fi
source $dir/ui.sh
source $dir/utils.sh

folderToBackup=$HOME
archiveName="home_$(basename $HOME)_$(date +%Y%m%d-%H%M%S).tar.gz"
archivePath="$HOME"
folderToBackup="$HOME/test" ######################## WATCH OUT __ OVERRIDEN!!
verbose=false

validate_path() {
    path="$1"
    if [[ -f "$path" ]]; then
        error "'$path' jest plikiem"
        return 1
    fi
    if [[ ! -d "$path" ]]; then
        error "folder '$path' nie istnieje"
        return 2
    fi
    return 0
}

check_if_file_exists() {
    validate_path $archivePath
    validate="$?"
    if [[ "$validate" -gt 0 ]]; then
        return 1
    fi
    if [[ -f "$archivePath/$archiveName" ]]; then
        local overwrite
        read -rp "Plik '$archivePath/$archiveName' już istnieje, nadpisać? [t/N] " overwrite
        case $overwrite in
        t | T | y | Y) return 0 ;;
        n | N | *) return 3 ;;
        esac
    fi
    return 0
}

validate_filename() {
    filename="$1"
    # długość
    if [ "${#filename}" -gt 255 ]; then
        error "Nazwa pliku nie może być dłuższa niż 255 znaków"
        return 1
    fi
    if ! [[ "$filename" =~ ^[0-9a-zA-Z._-]+$ ]]; then
        error "Użyto niepoprawnych znaków"
        return 2
    fi
    firstchar=$(echo $filename | cut -c1-1)
    if ! [[ "$firstchar" =~ ^[0-9a-zA-Z]+$ ]]; then
        error "Niedozwolone użycie '$firstchar' jako pierwszego znaku"
        return 3
    fi
    return 0
}

make_backup() {
    check_if_file_exists
    if [[ $? -ne 0 ]]; then return 4; fi
    textcolor cyan
    echo "Tworzę kopię zapasową..."
    resetstyle
    fullpath="$archivePath/$archiveName"
    
    if [[ "$verbose" = true ]]; then
        tar --exclude="$fullpath" -cvzf "$fullpath" "$folderToBackup"
    else
        tar --exclude="$fullpath" -czf "$fullpath" "$folderToBackup"
    fi
    textcolor green
    echo "Utworzono kopię zapasową '$archiveName'"
    resetstyle
    pause
}

switch_verbose() {
    if [[ "$verbose" = true ]]; then
        verbose=false
    else
        verbose=true
    fi
}

reset_archive_name() {
    archiveName="home_$(basename $HOME)_$(date +%Y%m%d-%H%M%S).tar.gz"
}

make_backup_update_time() {
    reset_archive_name
    make_backup
}

change_archive_name() {
    local newname
    read -rp "Wpisz nazwę (bez rozszerzenia): " newname
    validate_filename "$newname"
    res="$?"
    while [[ "$res" -ne 0 ]]; do
        read -rp "Wpisz nazwę (bez rozszerzenia): " newname
        validate_filename "$newname"
        res="$?"
    done
    archiveName="$newname.tar.gz"
}

change_save_path() {
    local newpath
    read -rp "Wpisz ścieżkę: " newpath
    validate_path "$newpath"
    res="$?"
    while [[ "$res" -ne 0 ]]; do
        read -rp "Wpisz ścieżkę: " newpath
        validate_path "$newpath"
        res="$?"
    done
    archivePath="$newpath"
}

show_backup_menu() {
    thin_divider
    printcenter "BACKUP"
    echo "Folder do zbackupowania: $(textcolor green)$folderToBackup"
    resetstyle
    echo "Docelowa nazwa archiwum: $(textcolor green)$archiveName"
    resetstyle
    echo "Miejsce zapisu:          $(textcolor green)$archivePath"
    resetstyle
    if [[ "$verbose" = true ]]; then
        echo "Szczegółowe wypisywanie: $(textcolor green)tak"
    else
        echo "Szczegółowe wypisywanie: $(textcolor yellow)nie"
    fi
    resetstyle
    thick_divider
    echo "1. Utwórz kopię zapasową"
    echo "2. Utwórz kopię zapasową (z domyślną, zaktualizowaną nazwą)"
    thin_divider
    echo "3. Zmień nazwę archiwum"
    echo "4. Zmień miejsce zapisu"
    echo "7. Zmień folder do zbackupowania"
    thin_divider
    echo "5. Przestaw szczegółowe wypisywanie programu tar"
    echo "6. Przywróć/aktualizuj domyślną nazwę archiwum"
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
    6) reset_archive_name ;;
    7) change_archived_path ;;
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
