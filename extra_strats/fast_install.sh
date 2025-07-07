#!/bin/bash
set -e

#Запрос на установку 3x-ui или аналогов
read -p "Install tunneling software?: (3xui, marzban, wg, 3proxy or Enter for none): " answer
# Удаляем лишние символы и пробелы, приводим к верхнему регистру
clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
if [[ -z "$clean_answer" ]]; then
    echo "Skipping tunneling soft installation (default action)."
elif [[ "$clean_answer" == "3XUI" ]]; then
    echo "Installing 3x-ui panel..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
elif [[ "$clean_answer" == "WG" ]]; then
    echo "Installing wg..."
    bash <(curl -Ls https://raw.githubusercontent.com/angristan/wireguard-install/refs/heads/master/wireguard-install.sh)
elif [[ "$clean_answer" == "3PROXY" ]]; then
    echo "Installing 3proxy..."
    bash <(curl -Ls https://raw.githubusercontent.com/SnoyIatk/3proxy/master/3proxyinstall.sh)
    wget -O /etc/3proxy/.proxyauth https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/del.proxyauth
    wget -O /etc/3proxy/3proxy.cfg https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/3proxy.cfg
    #mv del.proxyauth .proxyauth
    #mv .proxyauth /etc/3proxy/
    #mv 3proxy.cfg /etc/3proxy/
    systemctl restart 3proxy
elif [[ "$clean_answer" == "MARZBAN" ]]; then
    bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban.sh)" @ install
else
    echo "Skipping tunneling soft installation."
fi

#Запрос на подбор стратегий 
read -p "Find strategy? (zeefeer/zapret must be installed early) Write digital or press Enter: (1: YT (UDP QUIC), 2: YT (TCP), 3: RKN, 4: New domain, Enter for none): " answer
clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]') # Удаляем лишние символы и пробелы, приводим к верхнему регистру

if [[ -z "$clean_answer" ]]; then
    echo "Skipping finding extra strats (default action)"

elif [[ "$clean_answer" == "1" ]]; then
    echo "Mode: Finding strategy for YT (UDP QUIC) activated"
    # Цикл от 1 до 8
    for i in {1..8}; do

        if [[ $i -ge 2 ]]; then
            prev=$((i - 1))
            echo -n > "/opt/zapret/extra_strats/UDP/YT/${prev}.txt"
        fi

        cp "/opt/zapret/extra_strats/UDP/YT/List.txt" "/opt/zapret/extra_strats/UDP/YT/${i}.txt"

        systemctl restart zapret

        echo "Strategy $i activated"

        read -p "Test strategy in browser and write answer here (\"Y\" - Apply strategy, Enter for try next strategy): " answer
        clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

        if [[ "$clean_answer" == "Y" ]]; then
            echo "Strategy $i applied and exiting."
            exit 0
        fi
    done

    # После цикла
    echo -n > "/opt/zapret/extra_strats/UDP/YT/8.txt"
    echo "End strategy lists. All was tried"
    exit 0
	
elif [[ "$clean_answer" == "2" ]]; then
    echo "Mode: Finding strategy for YT (TCP) activated"
    # Цикл от 1 до 17
    for i in {1..17}; do

        if [[ $i -ge 2 ]]; then
            prev=$((i - 1))
            echo -n > "/opt/zapret/extra_strats/TCP/YT/${prev}.txt"
        fi

        cp "/opt/zapret/extra_strats/TCP/YT/List.txt" "/opt/zapret/extra_strats/TCP/YT/${i}.txt"

        systemctl restart zapret

        echo "Strategy $i activated"

        read -p "Test strategy in browser and write answer here (\"Y\" - Apply strategy, Enter for try next strategy): " answer
        clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

        if [[ "$clean_answer" == "Y" ]]; then
            echo "Strategy $i applied and exiting."
            exit 0
        fi
    done

    # После цикла
    echo -n > "/opt/zapret/extra_strats/TCP/YT/17.txt"
    echo "End strategy lists. All was tried"
    exit 0
    
elif [[ "$clean_answer" == "3" ]]; then
    echo "Mode: Finding strategy for RKN lists activated"
    # Цикл от 1 до 17
    for i in {1..17}; do

        if [[ $i -ge 2 ]]; then
            prev=$((i - 1))
            echo -n > "/opt/zapret/extra_strats/TCP/RKN/${prev}.txt"
        fi

        cp "/opt/zapret/extra_strats/TCP/RKN/List.txt" "/opt/zapret/extra_strats/TCP/RKN/${i}.txt"

        systemctl restart zapret

        echo "Strategy $i activated"

        read -p "Test strategy in browser and write answer here (\"Y\" - Apply strategy, Enter for try next strategy): " answer
        clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

        if [[ "$clean_answer" == "Y" ]]; then
            echo "Strategy $i applied and exiting."
            exit 0
        fi
    done

    # После цикла
    echo -n > "/opt/zapret/extra_strats/TCP/RKN/17.txt"
    echo "End strategy lists. All was tried"
    exit 0

elif [[ "$clean_answer" == "4" ]]; then
    echo "Mode: Finding strategy for new domain activated"

	read -p "Input domain please (example, mydomain.com): " user_domain
	user_domain=$(echo "$user_domain" | tr -d '[:space:]')  # удаляем лишние пробелы
    # Цикл от 1 до 17
    for i in {1..17}; do
		#Найти и отключить временно общий лист
		for emp in {1..17}; do
			file="/opt/zapret/extra_strats/TCP/RKN/${emp}.txt"
			if [[ -s "$file" ]]; then
				#echo "$emp"
				echo -n > "/opt/zapret/extra_strats/TCP/RKN/${emp}.txt"
				break
			fi
		done

        if [[ $i -ge 2 ]]; then
            prev=$((i - 1))
            echo -n > "/opt/zapret/extra_strats/TCP/temp/${prev}.txt"
        fi

        echo "$user_domain" > "/opt/zapret/extra_strats/TCP/temp/${i}.txt"

        systemctl restart zapret

        echo "Strategy $i activated"

        read -p "Test strategy in browser and write answer here (\"Y\" - Apply strategy, Enter for try next strategy): " answer
        clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

        if [[ "$clean_answer" == "Y" ]]; then
			echo -n > "/opt/zapret/extra_strats/TCP/temp/${i}.txt" #Очищаем temp
			echo "$user_domain" > "/opt/zapret/extra_strats/TCP/User/${i}.txt" #Кидаем в юзерлист на постоянку в приоритет
			cp "/opt/zapret/extra_strats/TCP/RKN/List.txt" "/opt/zapret/extra_strats/TCP/RKN/${emp}.txt" #Включить обратно общий лист
            echo "Strategy $i applied and exiting."
            exit 0
        fi
    done

    # После цикла
    echo -n > "/opt/zapret/extra_strats/TCP/temp/17.txt"
    echo "End strategy lists. All was tried"
    exit 0
 
else
    echo "Skipping finding extra strats (default action)"
fi

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

# Распаковка архива zapret и его удаление
wget https://github.com/bol-van/zapret/releases/download/v71.1/zapret-v71.1.zip
unzip zapret-v71.1.zip
rm -f zapret-v71.1.zip
mv zapret-v71.1 zapret

#Клонируем репозиторий и забираем папки lists и fake, удаляем репозиторий
git clone https://github.com/IndeecFOX/zapret4rocket.git
cp -r zapret4rocket/lists /opt/zapret/
cp -r zapret4rocket/fake /opt/zapret/files/
cp -r zapret4rocket/extra_strats /opt/zapret/
rm -rf zapret4rocket
#chmod -R 777 /opt/zapret/fake
#chmod -R 777 /opt/zapret/lists

#Копирование нашего конфига на замену стандартному
wget -O config.default https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/master/extra_strats/config.default
mv config.default /opt/zapret/

# Запуск установочных скриптов
sh zapret/install_bin.sh
sh zapret/install_prereq.sh
sh -i zapret/install_easy.sh

# Перезагрузка zapret с помощью systemd
echo "Перезагружаем zapret..."
systemctl restart zapret
echo "Установка завершена"
