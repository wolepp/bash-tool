#!/usr/bin/env bash

emerg() {
    check=$(journalctl -p crit --no-pager | wc -l)
    if [[ "$check" -eq 2 ]]; then
        echo "Brak logów o najwyższym priorytecie"
    else
        journalctl -p crit
    fi
}

emerg