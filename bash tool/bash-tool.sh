#!/usr/bin/env bash
# Wojciech Lepich

Help() {
echo "Użycie: ./bash-tool.sh [-h]"
echo ""
echo "Interaktywny program umożliwiający:"
echo "    tworzenie kopii zapasowych"
echo "    przywracanie kopii zapasowych"
echo "    sprawdzenia zdrowia dysków (przy pomocy fsck)"
echo "    odczytywania logów systemowych"
echo ""
echo "Aby anulować zapytanie (np. o podanie nowej ścieżki, nazwy)"
echo "należy pozostawić puste pole i wcisnąć [Enter]"
echo ""
echo "Kopie zapasowe domyślnie tworzone są w folderze domowym."
echo "W celach bezpieczeństwa zalecana zmiana miejsca utworzenia"
echo "na inny dysk lub późniejsze skopiowanie jej w bezpieczne miejsce."
echo ""
echo "Do działania z kopiami zapasowymi wymagany 'tar'"
echo "Do sprawdzenia zdrowia dysków wymagany 'fsck'"
echo ""
echo "Logi systemowe odczytywane przez 'journalctl' na systemach z systemd"
echo "lub z folderu '/var/log/' na systemach z sysvinit"
echo ""
echo "Argumenty:"
echo "    -h pokazuje tę pomoc i kończy działanie"
}

while getopts ":h" option; do
    case $option in
        h)
            Help
            exit 0
            ;;
        *)
            echo "Nieznana opcja $option."
            exit 1
            ;;
    esac
done

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$dir/ui.sh"
source "$dir/utils.sh"

backup() {
    run backup.sh "$dir"
}

restore() {
    run restore.sh "$dir"
}

diskHealth() {
    run disk-health.sh "$dir"
}

systemLogs() {
    run system-logs.sh "$dir"
}

showProcesses() {
    echo "Tylko ten $0" && sleep 1
}

showDir() {
    echo $dir && sleep 2
    echo "$dir/ui.sh" && sleep 2
    pause
}

unknownOption() {
    tput setaf 1
    echo "Unknown option..." && sleep 2
    tput reset
}

read_options() {
    local choice
    read -rp "Wybierz opcję [0-4]: " choice
    case $choice in
    dir) showDir ;;
    1) backup ;;
    2) restore ;;
    3) diskHealth ;;
    4) systemLogs ;;
    0) exit 0 ;;
    esac
}

show_main_menu() {
    clear
    thin_divider
    printcenter "MENU GŁÓWNE"
    printcenter "Witaj w programie bash-tool." 2
    echo "Dostępne programy:"
    echo "   1. backup"
    echo "   2. przywracanie"
    echo "   3. disk health"
    echo "   4. logi systemowe"
    echo "   0. wyjście"
    thin_divider
}

# =========== MAIN LOOP
tput norm
tput clear
tput sgr0
tput rc
while true; do
    tput reset
    show_main_menu
    read_options
done
