# bash-tool

Narzędzie do administracji, napisane w bashu
Jeden z projektów zaliczeniowych na ćwiczenia Języki Skryptowe

Program umożliwia:

- tworzenie kopii zapasowej wybranego folderu (tworzy archiwum)
- przywrócenie kopii zapasowej (wraz ze znalezieniem najnowszej wersji kopii zapasowej)
- sprawdzenie stanu zdrowia dysków
- przejrzenie logów systemowych (systemd-logs oraz sysvinit)

## Uruchomienie

W folderze `bash tool` znajduje się główny skrypt `bash-tool.sh`. Można go uruchomić poleceniem `bash bash-tool.sh` lub dodając uprawnienia wykonywalne `chmod +x bash-tool.sh`, a następnie poleceniem `./bash-tool.sh`.

## Zrzuty ekranu

### Menu główne

![Główne menu](screenshots/main-menu.png?raw=true "Główne menu")

### Menu kopii zapasowej i przywracanie

![Menu kopii zapasowej](screenshots/backup-menu.png?raw=true "Menu kopii zapasowej")

![Menu przywracania](screenshots/restore-menu.png?raw=true "Menu przywracania")

### Menu zdrowia dysków

![Menu zdrowia dysków](screenshots/disk-health-menu.png?raw=true "Menu zdrowia dysków")

### Menu logów systemowych

![Menu logów systemowych](screenshots/system-logs-menu.png?raw=true "Menu logów systemowych")

