dir=$1
source $dir/ui.sh
source $dir/utils.sh

declare -A disks
declare -a selected_to_check
verbose=false

# do tabeli
path_idx=0
fstype_idx=1
model_idx=2
hotplug_idx=3
size_idx=4
# name fstype model hotplug size
header="\n   %-12s %6s %20s %5s %8s\n"
format="   %-12s %6s %20s %5s %8s\n"
table_width=55
divider="============================"
divider="$divider$divider"


check_selected_disks() {
    info "Sprawdzam zdrowie wybranych dysków..."
    for disk in ${selected_to_check[@]}; do
        local path=(${disks[\"$disk\"]})
        echo "path: $path"
        echo "fsck "$path""
        # TODO: dlaczego to niżej nie działa?!
        fsck -n $path
    done
    pause
}

check_all_but_root() {
    info "Wszystkie bez roota"
    pause
}

check_not_mounted() {
    info "Wszystkie niezamontowane"
    pause
}

choose_disks() {
    local chosen
    read -rp "Dysk: " chosen
    if [[ "${!disks[@]}" =~ "${chosen}" ]]; then
        if [[ " ${selected_to_check[@]} " =~ "${chosen}" ]]; then
            info "Dysk jest już wybrany" && pause
        else
            selected_to_check+=("$chosen")
        fi
    else 
        error "Nie ma takiego dysku ('$chosen')"
    fi
}

unchoose_disk() {
    local unchosen
    read -rp "Dysk: " unchosen
    if [[ "${!disks[@]}" =~ "${unchosen}" ]]; then
        if [[ ! " ${selected_to_check[@]} " =~ "${unchosen}" ]]; then
            info "Ten dysk nie był wybrany" && pause
        else
            local new_selected=()
            for sel in "${selected_to_check[@]}"; do
                [[ $sel != "$unchosen" ]] && new_selected+=($sel)
            done
            selected_to_check=("${new_selected[@]}")
        fi
    else 
        error "Nie ma takiego dysku ('$unchosen')"
    fi
}

find_disks() {
    while read -r dev; do
        IFS=" " read -r name path fstype model hotplug size <<< "$(echo "$dev" | awk '{
            delete keys;
            for(i = 1; i <= NF; ++i) {
                n = index($i, "=");
                if(n) {
                    vars[substr($i, 1, n-1)] = substr($i, n+1)
                }
            }
            name        = vars["NAME"]
            path        = vars["PATH"]
            fstype      = vars["FSTYPE"]
            model       = vars["MODEL"]
            hotplug     = vars["HOTPLUG"]
            size        = vars["SIZE"]
        } {
            print name, path, fstype, model, hotplug, size
        }' )"
        if [[ ! "$name" =~ loop.* ]]; then
            disks["$name"]="$path $fstype $model $hotplug $size"
        fi
    done < <(lsblk -PO)
}

print_disks() {
    for diskname in "${!disks[@]}"; do
        echo "$diskname"
    done | sort -k1
}

print_disk_info_table() {
    printf "$header" "dysk" "system" "model" "usb" "rozmiar"
    printf "   %$table_width.${table_width}s\n" "$divider"
    for disk in $(print_disks); do
        local info=(${disks[$disk]})
        local name="${disk%\"}"
        name="${name#\"}"
        local fstype=${info[fstype_idx]}
        fstype="${fstype%\"}"
        fstype="${fstype#\"}"
        local model=${info[model_idx]}
        model="${model%\"}"
        model="${model#\"}"
        local hotplug=${info[hotplug_idx]}
        if [[ "$hotplug" =~ "1" ]]; then
            hotplug="tak"
        else
            hotplug="nie"
        fi
        local size=${info[size_idx]}
        size="${size%\"}"
        size="${size#\"}"

        printf "$format" \
        "$name" "$fstype" "$model" "$hotplug" "$size"
    done
}

switch_verbose() {
    if [[ "$verbose" = true ]]; then
        verbose=false
    else
        verbose=true
    fi
}

show_diskhealth_menu() {
    thin_divider
    printcenter "DISK-HEALTH"
    print_disk_info_table
    echo
    echo "Do sprawdzenia:          ${selected_to_check[@]}"
    if [[ "$verbose" = true ]]; then
        echo "Szczegółowe wypisywanie: $(textcolor green)tak$(resetstyle)"
    else
        echo "Szczegółowe wypisywanie: $(textcolor yellow)nie$(resetstyle)"
    fi
    echo
    thick_divider
    echo
    echo "Sprawdź zdrowie:"
    echo "  1. wybranych dysków"
    echo "  2. wszystkich dysków z wyłączeniem roota"
    echo "  3. wszystkich niezamontowanych dysków"
    thin_divider
    echo "5. Wybierz dyski do sprawdzenia"
    echo "6. Zrezygnuj z dysku do sprawdzenia"
    thin_divider
    echo "8. Przestaw szczegółowe wypisywanie programu fsck"
    echo "0. Powrót"
    thin_divider
}

read_options() {
    local choice
    read -rp "Wpisz opcję: " choice
    case $choice in
    1) check_selected_disks ;;
    2) check_all_but_root ;;
    3) check_not_mounted ;;
    5) choose_disks ;;
    6) unchoose_disk ;;
    8) switch_verbose ;; 
    0) exit 0 ;;
    esac
}

# ============================== Main Loop
tput clear
tput rc
find_disks
while true; do
    tput reset
    show_diskhealth_menu
    read_options
done
