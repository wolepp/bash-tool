dir="$1"
source "$dir/ui.sh"
source "$dir/utils.sh"

logsdir="logs"

if [[ -f /etc/init.d/cron && ! -h /etc/init.d/cron ]]; then
    logs_script="sysv-logs.sh"
elif [[ `systemctl` =~ -\.mount ]]; then
    logs_script="systemd-logs.sh"
else
    error "Brak obsługi obecnego systemu inicjalizującego"
    exit 1
fi

run "$logsdir/$logs_script" "$dir"
