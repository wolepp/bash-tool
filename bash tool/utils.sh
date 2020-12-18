run() {
    script="$1"
    shift
    /usr/bin/env bash "$dir/$script" "$@"
}

pause() {
    read -rp "Wciśnij [Enter] by kontynuować..."
}

error() {
    local e=${1:-"undefined error"}
    echo "$0: $(textcolor red)$e$(resetstyle)"
    pause
}

info() {
    echo "$(textcolor cyan)$1$(resetstyle)"
}

success() {
    echo "$(textcolor green)$1$(resetstyle)"
}

does_command_exist() {
    if command -v "$1" &> /dev/null; then
        return 0
    fi
    return 1
}

validate_archive_path() {
    local path="$1"
    if [ ! -f "$path" ]; then
        error "'$path' nie istnieje"
        return 1
    fi
    gzip -t "$path" >/dev/null 2>&1
    if [[ "$?" -ne 0 ]]; then
        echo "Plik nie jest archiwum"
        return 2
    fi
    return 0
}

validate_dir_path() {
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
