# Opis opcji journalctl

## czas
journalctl --utc

## poprzednie bootowania
journalctl --list-boots

### ile jest maksymalnie 
journalctl --list-boots | head -n1 | cut -f1 -d' '

## Który boot 
journalctl -b
### Sprzed dwóch
journalctl -b -2


## konkretny przedział czasowy
journalctl --since YYYY-MM-DD HH:MM:SS --until YYYY-MM-DD HH:MM:SS
journalctl --since YYYY-MM-DD --until YYYY-MM-DD HH:MM:SS
journalctl --since yesterday
journalctl --since 09:00 --until "1 hour ago"

## konkretny serwis
journalctl -u nginx.service
journalctl -u nginx.service -u php-fpm.service --since today

## node, np. plik, executable; jak nie node to zwraca 1
journalctl /home/wojtek/restore.sh
journalctl /usr/bin/bash

## logi z kernela
journalctl -k        ## tylko obecny boot
journalctl -k -b -5  ## sprzed 5 bootów

## tylko o zadanym priorytecie
journalctl -p err

### Z obecnego boota
journalctl -p err -b
### dostępne priorytety
0: emerg
1: alert
2: crit
3: err
4: warning
5: notice
6: info
7: debug

## od najnowszych
journalctl --reverse

## dziesięć najnowszych / 20
journalctl -n
journalctl -n 20

## ile zajmują obecnie logi
journalctl --disk-usage
