dir=$1
source $dir/ui.sh
source $dir/utils.sh

restorePath="$HOME/testRestore"
backupPath=""
backupsDir="$HOME"

defaultBackupNameRegex="home_$(basename $HOME)_[0-9]{8}-[0-9]{6}\.tar\.gz"
template="home_$(basename $HOME)_YYYYmmdd-HHMMSS"
verbose=false

restore_backup() {
    if [ -z $backupPath ]; then
        error "Nie wybrano pliku z kopią zapasową"
        return 1
    fi
    info "Przywracam kopię zapasową..."
    
    if [[ "$verbose" = true ]]; then
        tar -xvzf "$backupPath" -C "$restorePath"
    else
        tar -xzf "$backupPath" -C "$restorePath"
    fi
    success "Utworzono kopię zapasową w '$restorePath'"
    pause
}

find_newest_backup() {
    for str in $backupsDir/*; do
        if [[ "$str" =~ $defaultBackupNameRegex ]]; then
            newest="$str"
        fi
    done
    if [ -z $newest ]; then
        textcolor red
        echo "Nie znaleziono kopii zapasowej wg wzorca '$template'"
        resetstyle
        pause
    else
        backupPath="$newest"
    fi
}

choose_backup_file() {
    local backupfile
    echo "Wpisz nazwę kopii zapasowej (lub pełną ścieżkę, jeśli kopia"
    echo "nie znajduje się w folderze z kopiami zapasowymi"
    read -rp "Wpisz nazwę/ścieżkę: " backupfile
    if [[ ! "$backupfile" =~ /.* ]]; then
        backupfile="$backupsDir/$backupfile"
    fi

    validate_archive_path "$backupfile"
    res="$?"
    while [[ "$res" -ne 0 ]]; do
        read -rp "Wpisz nazwę/ścieżkę: " backupfile
        if [[ ! "$backupfile" =~ /.* ]]; then
            backupfile="$backupsDir/$backupfile"
        fi
        validate_archive_path "$backupfile"
        res="$?"
    done
    backupPath="$backupfile"
}

change_archives_dir() {
    local dir
    read -rp "Ścieżka folderu: " dir
    validate_dir_path "$dir"
    res="$?"
    while [[ "$res" -ne 0 ]]; do
        read -rp "Ścieżka folderu: " dir
        validate_dir_path "$dir"
        res="$?"
    done
    backupsDir="$dir"
}

change_path_to_restore() {
    local path
    read -rp "Ścieżka docelowa: " dir
    validate_dir_path "$dir"
    res="$?"
    while [[ "$res" -ne 0 ]]; do
        read -rp "Ścieżka docelowa: " dir
        validate_dir_path "$dir"
        res="$?"
    done
    restorePath="$dir"
}

show_restore_menu() {
    thin_divider
    printcenter "RESTORE"
    echo
    echo "Plik z kopią:                $(textcolor green)$backupPath"
    resetstyle
    echo "Gdzie przywrócić:            $(textcolor green)$restorePath"
    resetstyle
    echo "Folder z kopiami zapasowymi: $(textcolor green)$backupsDir"
    resetstyle
    echo "Wzorzec wyszukujący:         $(textcolor cyan)$template"
    resetstyle
    if [[ "$verbose" = true ]]; then
        echo "Szczegółowe wypisywanie:     $(textcolor green)tak"
    else
        echo "Szczegółowe wypisywanie:     $(textcolor yellow)nie"
    fi
    resetstyle
    echo
    thick_divider
    echo
    echo "1. Przywróć kopię zapasową"
    thin_divider
    echo "3. Znajdź najnowszą kopię wg wzorca w folderze z kopiami"
    echo "4. Wybierz ręcznie plik z kopią zapasową"
    thin_divider
    echo "6. Zmień folder z kopiami zapasowymi"
    echo "7. Zmień docelowe miejsce przywrócenia kopii"
    thin_divider
    echo "8. Przestaw szczegółowe wypisywanie programu tar"
    thin_divider
    echo "0. Powrót"
    thin_divider
}

switch_verbose() {
    if [[ "$verbose" = true ]]; then
        verbose=false
    else
        verbose=true
    fi
}

read_options() {
    local choice
    read -rp "Wpisz opcję: " choice
    case $choice in
    1) restore_backup ;;
    3) find_newest_backup ;;
    4) choose_backup_file ;;
    6) change_archives_dir ;;
    7) change_path_to_restore ;;
    8) switch_verbose ;;
    0) exit 0 ;;
    esac
}

# ============================== Main Loop
tput clear
tput rc
while true; do
    tput reset
    show_restore_menu
    read_options
done
