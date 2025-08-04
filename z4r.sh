#!/bin/bash
#Команда установки
#curl -O https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/z4r.sh && bash z4r.sh && rm z4r.sh
#В случае отсутствия curl или bash: 
#Для keenetic entware/OWRT: opkg update && opkg install curl bash
#Для Ubuntu/Debian: apt update && apt install curl bash

set -e

#ОТКЛЮЧЕНО Какую версию zapret использовать, если юзер не попросит другую
#DEFAULT_VER="71.3"

#Чтобы удобнее красить
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
plain='\033[0m'

#Проверка ОС
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    release=$ID
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
    release=$ID
elif [[ -f /opt/etc/entware_release ]]; then
    release="entware"
elif [[ -f /etc/entware_release ]]; then
    release="entware"
else
    echo "Не удалось определить ОС. Прекращение работы скрипта." >&2
    exit 1
fi
echo "OS: $release"

try_strategies() {
    local count="$1"
    local base_path="$2"
    local list_file="$3"
    local final_action="$4"

    for ((i=1; i<=count; i++)); do
        if [[ $i -ge 2 ]]; then
            prev=$((i - 1))
            echo -n > "$base_path/${prev}.txt"
        fi

        if [[ "$list_file" != "/dev/null" ]]; then
            cp "$list_file" "$base_path/${i}.txt"
        else
            echo "$user_domain" > "$base_path/${i}.txt"
        fi

        /opt/zapret/init.d/sysv/zapret restart
        echo "Стратегия номер $i активирована"

        read -p "Проверьте работоспособность, например, в браузере и введите (\"Y\" - сохранить, Enter - далее): " answer
        clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
        if [[ "$clean_answer" == "Y" ]]; then
            echo "Стратегия $i сохранена. Выходим."
            eval "$final_action"
            exit 0
        fi
    done

    echo -n > "$base_path/${count}.txt"
    echo "Все стратегии испробованы. Ничего не подошло."
    exit 0
}

Strats_Tryer() {
    if [ ! -f "/opt/zapret/uninstall_easy.sh" ]; then
        echo "zapret не установлен, пропускаем скрипт подбора профиля"
        return
    fi

    read -p $'\033[33mПодобрать стратегию? (1-4 или Enter для пропуска):\033[0m\n\033[32m1. YT (UDP QUIC)\n2. YT (TCP)\n3. RKN\n4. Кастомный домен\033[0m\n' answer
    clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

    case "$clean_answer" in
        "1")
            echo "Режим YT (UDP QUIC)"
            try_strategies 8 "/opt/zapret/extra_strats/UDP/YT" "/opt/zapret/extra_strats/UDP/YT/List.txt" ""
            ;;
        "2")
            echo "Режим YT (TCP)"
            try_strategies 17 "/opt/zapret/extra_strats/TCP/YT" "/opt/zapret/extra_strats/TCP/YT/List.txt" ""
            ;;
        "3")
            echo "Режим RKN"
            try_strategies 17 "/opt/zapret/extra_strats/TCP/RKN" "/opt/zapret/extra_strats/TCP/RKN/List.txt" ""
            ;;
        "4")
            echo "Режим кастомного домена"
            read -p "Введите домен (например, mydomain.com): " user_domain
            user_domain=$(echo "$user_domain" | tr -d '[:space:]')

            # Отключаем активный RKN-лист временно
            for emp in {1..17}; do
                file="/opt/zapret/extra_strats/TCP/RKN/${emp}.txt"
                if [[ -s "$file" ]]; then
                    echo -n > "$file"
                    break
                fi
            done

            try_strategies 17 "/opt/zapret/extra_strats/TCP/temp" "/dev/null" \
            "echo -n > \"/opt/zapret/extra_strats/TCP/temp/\${i}.txt\"; \
             echo \"$user_domain\" > \"/opt/zapret/extra_strats/TCP/User/\${i}.txt\"; \
             cp \"/opt/zapret/extra_strats/TCP/RKN/List.txt\" \"/opt/zapret/extra_strats/TCP/RKN/${emp}.txt\""
            ;;
        *)
            echo "Пропуск подбора альтернативной стратегии"
            ;;
    esac
}

VPS() {
 #Запрос на установку 3x-ui или аналогов
 read -p $'\033[33mУстановить ПО для туннелирования?\033[0m \033[32m(3xui, marzban, wg, 3proxy или Enter для пропуска): \033[0m' answer
 # Удаляем лишние символы и пробелы, приводим к верхнему регистру
 clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
 if [[ -z "$clean_answer" ]]; then
     echo "Пропуск установки ПО туннелирования."
 elif [[ "$clean_answer" == "3XUI" ]]; then
     echo "Установка 3x-ui панели."
     bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
 elif [[ "$clean_answer" == "WG" ]]; then
     echo "Установка WG (by angristan)"
     bash <(curl -Ls https://raw.githubusercontent.com/angristan/wireguard-install/refs/heads/master/wireguard-install.sh)
 elif [[ "$clean_answer" == "3PROXY" ]]; then
     echo "Установка 3proxy (by SnoyIatk)"
     bash <(curl -Ls https://raw.githubusercontent.com/SnoyIatk/3proxy/master/3proxyinstall.sh)
     wget -O /etc/3proxy/.proxyauth https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/del.proxyauth
     wget -O /etc/3proxy/3proxy.cfg https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/3proxy.cfg
     #mv del.proxyauth .proxyauth
     #mv .proxyauth /etc/3proxy/
     #mv 3proxy.cfg /etc/3proxy/
     /opt/zapret/init.d/sysv/zapret restart
 elif [[ "$clean_answer" == "MARZBAN" ]]; then
     echo "Установка Marzban"
     bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban.sh)" @ install
 else
     echo "Пропуск установки ПО туннелирования."
 fi

 #Запрос на подбор стратегий
 Strats_Tryer

 # Обновление пакетов и установка unzip
 apt update && apt install -y unzip && apt install -y git

 # Переход в директорию /opt
 cd /opt

 #Удаление старого запрета, если есть
 if [ -f "zapret/uninstall_easy.sh" ]; then
     echo "Файл zapret/uninstall_easy.sh найден. Выполняем его"
     sh zapret/uninstall_easy.sh
     echo "Скрипт uninstall_easy.sh выполнен."
 else
     echo "Файл zapret/uninstall_easy.sh не найден. Переходим к следующему шагу."
 fi
 if [ -d "zapret" ]; then
     echo "Удаляем папку zapret"
     rm -rf zapret
     echo "Папка zapret успешно удалена."
 else
     echo "Папка zapret не существует."
 fi

 #Запрос желаемой версии zapret
  while true; do
    read -p "Введите желаемую версию zapret (Enter для новейшей): " USER_VER
    # Если пустой ввод — берем значение по умолчанию
    if [ -z "$USER_VER" ]; then
        #VER="$DEFAULT_VER"
        VER=$(wget -qO- https://api.github.com/repos/bol-van/zapret/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
        break
    fi
    # Проверяем длину не более 4 символов
    LEN=${#USER_VER}
    if [ "$LEN" -le 4 ]; then
        VER="$USER_VER"
        break
    else
        echo "Некорректный ввод. Максимальная длина — 4 символа. Попробуйте снова. (использование backspace может давать ошибку)"
    fi
 done
 echo "Будет использоваться версия: $VER"
 
 # Распаковка архива zapret и его удаление
 wget https://github.com/bol-van/zapret/releases/download/v$VER/zapret-v$VER.zip
 unzip zapret-v$VER.zip
 rm -f zapret-v$VER.zip
 mv zapret-v$VER zapret

 #Клонируем репозиторий и забираем папки lists и fake, удаляем репозиторий
 git clone https://github.com/IndeecFOX/zapret4rocket.git
 cp -r zapret4rocket/lists /opt/zapret/
 cp -r zapret4rocket/fake /opt/zapret/files/
 cp -r zapret4rocket/extra_strats /opt/zapret/
 rm -rf zapret4rocket

 #Копирование нашего конфига на замену стандартному
 wget -O config.default https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/master/extra_strats/config.default
 mv config.default /opt/zapret/

 # Запуск установочных скриптов
 sh -i zapret/install_easy.sh

 # Перезагрузка zapret с помощью systemd
 /opt/zapret/init.d/sysv/zapret restart
 echo -e "\033[32mzeefeer перезапущен и полностью установлен\033[0m"
}

WRT() {
 #Запрос на подбор стратегий
 Strats_Tryer
 
 #directories
 cd /
 if [ -d /opt ]; then
     echo "Каталог /opt уже существует"
 else
     echo "Создаём каталог /opt"
     mkdir /opt
 fi
 cd /opt
 
 #Удаление старого запрета, если есть
 if [ -f "zapret/uninstall_easy.sh" ]; then
     echo "Файл zapret/uninstall_easy.sh найден. Выполняем его"
     sh zapret/uninstall_easy.sh
     echo "Скрипт uninstall_easy.sh выполнен."
 else
     echo "Файл zapret/uninstall_easy.sh не найден. Переходим к следующему шагу."
 fi
 if [ -d "zapret" ]; then
     echo "Удаляем папку zapret"
     rm -rf zapret
     echo "Папка zapret успешно удалена."
 else
     echo "Папка zapret не существует."
 fi

#Запрос желаемой версии zapret
  while true; do
    read -p "Введите желаемую версию zapret (Enter для новейшей): " USER_VER
    # Если пустой ввод — берем значение по умолчанию
    if [ -z "$USER_VER" ]; then
        #VER="$DEFAULT_VER"
        VER=$(wget -qO- https://api.github.com/repos/bol-van/zapret/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
        break
    fi
    # Проверяем длину не более 4 символов
    LEN=${#USER_VER}
    if [ "$LEN" -le 4 ]; then
        VER="$USER_VER"
        break
    else
        echo "Некорректный ввод. Максимальная длина — 4 символа. Попробуйте снова. (использование backspace может давать ошибку)"
    fi
 done
 echo "Будет использоваться версия: $VER"
 
 # Распаковка архива zapret и его удаление
 wget -O zapret-v$VER-openwrt-embedded.tar.gz "https://github.com/bol-van/zapret/releases/download/v$VER/zapret-v$VER-openwrt-embedded.tar.gz"
 tar -xzf zapret-v$VER-openwrt-embedded.tar.gz
 rm -f zapret-v$VER-openwrt-embedded.tar.gz
 mv zapret-v$VER zapret
 
 read -p "Введите "S" если хотите пропустить установку git-http, клонирование репозитория и папок : " user_input
 if [ "${user_input^^}" != "S" ]; then
   echo "Выполняется установка git-http и копирование папок с репозитория"
   opkg update
   opkg install git-http
   git clone https://github.com/IndeecFOX/zapret4rocket.git
   cp -r zapret4rocket/lists /opt/zapret/
   cp -r zapret4rocket/fake /opt/zapret/files/
   cp -r zapret4rocket/extra_strats /opt/zapret/
   rm -rf zapret4rocket
 else
   echo "Skip установки git-http, клонирования репозитория и дёргания из него файлов."
 fi

 #Копирование нашего конфига на замену стандартному
 wget -O config.default https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/master/extra_strats/config.default
 mv config.default /opt/zapret/
 
 # Запуск установочных скриптов
 sh -i zapret/install_easy.sh
 /opt/zapret/init.d/sysv/zapret restart
 echo -e "\033[32mzeefeer перезапущен и полностью установлен\033[0m"
}

Entware() {
 #Запрос на подбор стратегий
 Strats_Tryer
 
 #preinstal env
 opkg install git-http coreutils-sort grep gzip ipset iptables kmod_ndms xtables-addons_legacy
 
 #directories
 cd /
 if [ -d /opt ]; then
     echo "Каталог /opt уже существует"
 else
     echo "Создаём каталог /opt"
     mkdir /opt
 fi
 cd /opt
 
 #Удаление старого запрета, если есть
 if [ -f "zapret/uninstall_easy.sh" ]; then
     echo "Файл zapret/uninstall_easy.sh найден. Выполняем его"
     echo Y | sh zapret/uninstall_easy.sh
     echo "Скрипт uninstall_easy.sh выполнен."
 else
     echo "Файл zapret/uninstall_easy.sh не найден. Переходим к следующему шагу."
 fi
 if [ -d "zapret" ]; then
     echo "Удаляем папку zapret"
     rm -rf zapret
     echo "Папка zapret успешно удалена."
 else
     echo "Папка zapret не существует."
 fi

#Запрос желаемой версии zapret
  while true; do
    read -p "Введите желаемую версию zapret (Enter для новейшей): " USER_VER
    # Если пустой ввод — берем значение по умолчанию
    if [ -z "$USER_VER" ]; then
        #VER="$DEFAULT_VER"
        VER=$(wget -qO- https://api.github.com/repos/bol-van/zapret/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
        break
    fi
    # Проверяем длину не более 4 символов
    LEN=${#USER_VER}
    if [ "$LEN" -le 4 ]; then
        VER="$USER_VER"
        break
    else
        echo "Некорректный ввод. Максимальная длина — 4 символа. Попробуйте снова. (использование backspace может давать ошибку)"
    fi
 done
 echo "Будет использоваться версия: $VER"
 
 # Распаковка архива zapret и его удаление
 wget -O zapret-v$VER-openwrt-embedded.tar.gz "https://github.com/bol-van/zapret/releases/download/v$VER/zapret-v$VER-openwrt-embedded.tar.gz"
 tar -xzf zapret-v$VER-openwrt-embedded.tar.gz
 rm -f zapret-v$VER-openwrt-embedded.tar.gz
 mv zapret-v$VER zapret
 
 #Клонируем репозиторий и забираем папки lists и fake, файлы для keenetic entware, удаляем репозиторий
 git clone https://github.com/IndeecFOX/zapret4rocket.git
 cp -r zapret4rocket/lists /opt/zapret/
 cp -r zapret4rocket/fake /opt/zapret/files/
 cp -r zapret4rocket/extra_strats /opt/zapret/
 cp -a zapret4rocket/Entware/zapret /opt/zapret/init.d/sysv/zapret
 chmod +x /opt/zapret/init.d/sysv/zapret
 echo "Права выданы /opt/zapret/init.d/sysv/zapret"
 cp -a zapret4rocket/Entware/000-zapret.sh /opt/etc/ndm/netfilter.d/000-zapret.sh
 chmod +x /opt/etc/ndm/netfilter.d/000-zapret.sh
 echo "Права выданы /opt/etc/ndm/netfilter.d/000-zapret.sh"
 cp -a zapret4rocket/Entware/S00fix /opt/etc/init.d/S00fix
 chmod +x /opt/etc/init.d/S00fix
 echo "Права выданы /opt/etc/init.d/S00fix"
 rm -rf zapret4rocket
 cp -a /opt/zapret/init.d/custom.d.examples.linux/10-keenetic-udp-fix /opt/zapret/init.d/sysv/custom.d/10-keenetic-udp-fix
 echo "10-keenetic-udp-fix скопирован"
 
 #Копирование нашего конфига на замену стандартному
 wget -O config.default https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/master/extra_strats/config.default
 mv config.default /opt/zapret/
 #Раскомменчивание юзера под keenetic
 sed -i 's/^#\(WS_USER=nobody\)/\1/' /opt/zapret/config.default
 
 # Запуск установочных скриптов
 #sed для пропуска запроса на прочтение readme, т.к. система entware. Дабы скрипт отрабатывал далее на Enter
 sed -i 's/if \[ -n "\$1" \] || ask_yes_no N "do you want to continue";/if true;/' /opt/zapret/common/installer.sh
 sh -i zapret/install_easy.sh
 ln -fs /opt/zapret/init.d/sysv/zapret /opt/etc/init.d/S90-zapret
 echo "Добавлено в автозагрузку: /opt/etc/init.d/S90-zapret > /opt/zapret/init.d/sysv/zapret"
 /opt/zapret/init.d/sysv/zapret restart
 echo -e "\033[32mzeefeer перезапущен и полностью установлен\033[0m"
}

#Запуск скрипта под нужную версию
if [[ "$release" == "ubuntu" || "$release" == "debian" ]]; then
    VPS
elif [[ "$release" == "openwrt" || "$release" == "immortalwrt" || "$release" == "asuswrt" ]]; then
    WRT
elif [[ "$release" == "entware" ]]; then
    Entware
else
    echo "Для этой ОС нет подходящей функции. Или ОС определение выполнено некорректно."
fi
