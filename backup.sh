dir=$1
source $dir/ui.sh
source $dir/utils.sh

folderToBackup=$HOME
archiveName="home_$(basename $HOME)_$(date +%Y%m%d-%H%M%S).tar.gz"
archivePath="$HOME"
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

change_folder_to_backup() {
    local newdir
    read -rp "Wpisz ścieżkę: " newdir
    validate_path "$newdir"
    res="$?"
    while [[ "$res" -ne 0 ]]; do
        read -rp "Wpisz ścieżkę: " newdir
        validate_path "$newdir"
        res="$?"
    done
    folderToBackup="$newdir"
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
    echo "4. Zmień nazwę archiwum"
    echo "5. Zmień miejsce zapisu"
    echo "6. Zmień folder do zbackupowania"
    thin_divider
    echo "8. Przestaw szczegółowe wypisywanie programu tar"
    echo "9. Przywróć/aktualizuj domyślną nazwę archiwum"
    thin_divider
    echo "0. Powrót"
    thin_divider
}

read_options() {
    local choice
    read -rp "Wpisz opcję: " choice
    case $choice in
    1) make_backup ;;
    2) make_backup_update_time ;;
    4) change_archive_name ;;
    5) change_save_path ;;
    6) change_folder_to_backup ;;
    8) switch_verbose ;;
    9) reset_archive_name ;;
    0) exit 0 ;;
    esac
}

# ============================== Main Loop
tput clear
tput rc
while true; do
    tput reset
    show_backup_menu
    read_options
done
