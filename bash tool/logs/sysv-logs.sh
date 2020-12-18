dir="$1"
source "$dir/ui.sh"
source "$dir/utils.sh"

keyword=""
logs_dir="/var/log"
standard_logs=("$logs_dir/messages" "$logs_dir/syslog" "$logs_dir/user.log" "$logs_dir/daemon.log")
kernel_logs=(${standard_logs[@]} "$logs_dir/kern.log")
reverse=true

all_logs=("$logs_dir/messages" "$logs_dir/syslog")
for log in /var/log/*; do
    echo "$log"
    if [[ -f "$log" && "$log" =~ .*\.log ]]; then
        all_logs+=("$log")
    fi
done

show_logs_with_criterias() {
    if [ -n "$keyword" ]; then
        if [[ "$reverse" = true ]]; then
            sudo cat "${all_logs[@]}" | tr -d '\000' | grep "$keyword" | sort -Mr | less
        else
            sudo cat "${all_logs[@]}" | tr -d '\000' | grep "$keyword" | sort -M | less
        fi
    else
        if [[ "$reverse" = true ]]; then
            sudo cat "${all_logs[@]}" | tr -d '\000' | sort -Mr | less
        else
            sudo cat "${all_logs[@]}" | tr -d '\000' | sort -M | less
        fi
    fi
}

show_logs_10_newest() {
    sudo cat "${all_logs[@]}" | tr -d '\000' | sort -Mr | head -n10 | less
}

show_logs_all_newest_first() {
    sudo cat "${all_logs[@]}" | tr -d '\000' | sort -Mr | less
}

show_logs_from_kernel() {
    sudo cat "${kernel_logs[@]}" | tr -d '\000' | sort -M | less
}

set_keyword() {
    read -rp "Słowo-klucz: " keyword
}

get_logs_size() {
    str=$(du -sh /var/log 2>/dev/null)
    if [[ "$str" =~ ([0-9]+(\.[0-9]+)?[^[:space:]]+) ]]; then
        logs_size="${BASH_REMATCH[1]}"
    else
        logs_size="unknown"
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
    echo ""
    echo "Wyświetlanie wielu plików z /var/log/ wymaga dostępu sudo."
    echo ""
    echo "Rozmiar logów: $(textcolor magenta)$logs_size$(resetstyle)"
    thin_divider
    echo "Kryteria (puste oznacza wszystkie)":
    echo "  słowo klucz:     $(textcolor cyan)$keyword$(resetstyle)"
    if [[ $reverse = true ]]; then
        echo "  wyświetlanie od: $(textcolor cyan)najnowszych $(resetstyle)"
    else
        echo "  wyświetlanie od: $(textcolor cyan)najstarszych $(resetstyle)"
    fi

    echo
    thick_divider
    echo

    echo "Ustawianie kryteriów"
    echo " k. ustaw słowo klucz - tylko logi z danym słowem"
    echo " r. zmień kolejność"
    thin_divider
    echo "Pokaż logi:"
    echo " 1. wg zastosowanych kryteriów"
    echo " 2. dziesięć najnowszych"
    echo " 3. wszystkie od najnowszego"
    echo " 4. z kernela"
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
    4) show_logs_from_kernel ;;
    k) set_keyword ;;
    r) switch_reverse ;;
    0) exit 0 ;;
    esac
}

# ============================== Main Loop
tput clear
tput rc
get_logs_size
while true; do
    tput reset
    show_system_logs_menu
    read_options
done