dir=$1
dir="/home/wojtek/Dev/bash-tool"
source $dir/ui.sh
source $dir/utils.sh

no_old_boots=false
reverse=true
boot=""
service=""
priority=""


get_logs_size() {
    str=$(journalctl --disk-usage)
    if [[ "$str" =~ ([0-9]+(\.[0-9]+)?[^[:space:]]+) ]]; then
        logs_size="${BASH_REMATCH[1]}"
    else
        logs_size="no match"
    fi
}

get_boots_list() {
    oldest_boot=$(journalctl --list-boots | head -n1 | cut -f1 -d' ')
    if [ -n "$oldest_boot" ]; then
        oldest_boot=${oldest_boot#-}
    else
        no_old_boots=true
    fi
}

show_logs() {
    onerror="$1"
    shift
    opts="$@"
    check=$(journalctl $opts | wc -l)
    if [[ "$check" -eq 2 ]]; then
        info "$onerror"
        pause
    else
        tput clear
        journalctl $opts
    fi
}

show_logs_no_check() {
    opts="$@"
    tput clear
    journalctl $opts
}

show_logs_with_criterias() {
    opts=""
    if [ -n "$boot" ]; then
        opts="$opts -b -$boot"
    fi
    if [ -n "$priority" ]; then
        opts="$opts -p $priority"
    fi
    if [[ "$reverse" = true ]]; then
        opts="$opts --reverse"
    fi
    if [ -n "$service" ]; then
        opts="$opts -u $service"
    fi
    show_logs_no_check $opts
}

show_logs_10_newest() {
    show_logs "Brak dostępnych logów" -n 10
}

show_logs_all_newest_first() {
    show_logs_no_check --reverse
}

show_logs_emerg_only() {
    show_logs "Brak logów o najwyższym priorytecie" -p emerg
}

show_logs_current_boot() {
    show_logs_no_check -b
}

show_logs_last_boot() {
    show_logs_no_check -b -1
}

show_logs_from_kernel() {
    show_logs_no_check -k
}

choose_boot() {
    local choice
    read -rp "Wpisz liczbę uruchomień wstecz [0-$oldest_boot]: " choice
    if [ -z "$choice" ]; then
        boot=""
        return
    fi

    if [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 0 && "$choice" -le $oldest_boot ]]; then
        boot="$choice"
    else
        error "Niepoprawny wybór: '$choice'"
    fi
}

choose_service() {
    local choice 
    read -rp "Wpisz nazwę serwisu: " choice
    if [ -z "$choice" ]; then
        service=""
        return
    fi

    [[ ! "$choice" =~ .*\.service ]] && choice="$choice.service"
    if systemctl list-units --full -all | grep -Fq "$choice"; then
        service="$choice"
    else
        error "Serwis '$choice' nie istnieje"
    fi
}

choose_priority() {
    local choice 
    read -rp "Wybierz priorytet [0-7]: " choice
    if [ -z "$choice" ]; then
        priority=""
    elif [[ "$choice" =~ ^[0-7]+$ && "$choice" -ge 0 && "$choice" -le 7 ]]; then
        case $choice in
        0) priority="emerg" ;;
        1) priority="alert" ;;
        2) priority="crit" ;;
        3) priority="err" ;;
        4) priority="warning" ;;
        5) priority="notice" ;;
        6) priority="info" ;;
        7) priority="debug" ;;
        esac
    else
        error "Niepoprawny wybór: '$choice'"
    fi
}

switch_reverse() {
    if [[ "$reverse" = true ]]; then
        reverse=false
    else
        reverse=true
    fi
}

show_system_logs_menu() {
    thin_divider
    printcenter "SYSTEM LOGS"
    echo "Rozmiar logów: $(textcolor magenta)$logs_size$(resetstyle)"
    if [[ $no_old_boots = false ]]; then
        echo "Dostępność logów do $(textcolor magenta)$oldest_boot$(resetstyle) uruchomień systemu wstecz"
    fi
    thin_divider
    echo "Kryteria (puste oznacza wszystkie)":
    echo "  priorytet:       $(textcolor cyan)$priority$(resetstyle)"
    echo "  serwis:          $(textcolor cyan)$service$(resetstyle)"
    if [ -z $boot ]; then
        echo "  uruchomienie:"
    else
        echo "  uruchomienie:    $(textcolor cyan)$boot$(resetstyle) wstecz"
    fi
    if [[ $reverse = true ]]; then
        echo "  wyświetlanie od: $(textcolor cyan)najnowszych $(resetstyle)"
    else
        echo "  wyświetlanie od: $(textcolor cyan)najstarszych $(resetstyle)"
    fi

    echo
    thick_divider
    echo

    echo "Ustawianie kryteriów"
    echo " b. wybierz uruchomienie (0 - teraz, 1 - poprzednie, itd.)"
    echo " s. wybierz serwis"
    echo " p. wybierz priorytet"
    echo " r. zmień kolejność"
    thin_divider
    echo "Pokaż logi:"
    echo " 1. wg zastosowanych kryteriów (nie otwarcie znaczy brak znalezionych logów wg kryteriów)"
    echo " 2. dziesięć najnowszych"
    echo " 3. wszystkie od najnowszego"
    echo " 4. tylko z najwyższym priorytetem"
    echo " 5. z obecnego uruchomienia"
    echo " 6. z poprzedniego uruchomienia"
    echo " 7. z kernela"
    thin_divider
    echo "Dostępne priorytety:"
    echo "    0) emerg"
    echo "    1) alert"
    echo "    2) crit"
    echo "    3) err"
    echo "    4) warning"
    echo "    5) notice"
    echo "    6) info"
    echo "    7) debug"
    thin_divider
    echo "0. Powrót"
    thin_divider
}

read_options() {
    local choice
    read -rp "Wpisz opcję: " choice
    case $choice in
    1) show_logs_with_criterias ;;
    2) show_logs_10_newest ;;
    3) show_logs_all_newest_first ;;
    4) show_logs_emerg_only ;;
    5) show_logs_current_boot ;;
    6) show_logs_last_boot ;;
    7) show_logs_from_kernel ;;
    b) choose_boot ;;
    s) choose_service ;;
    p) choose_priority ;;
    r) switch_reverse ;;
    0) exit 0 ;;
    esac
}

# ============================== Main Loop
tput clear
tput rc
get_logs_size
get_boots_list
while true; do
    tput reset
    show_system_logs_menu
    read_options
done