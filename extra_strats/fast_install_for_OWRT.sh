#SSH Install command: opkg install bash curl && bash <(curl -Ls https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/fast_install_for_OWRT.sh)

#New Script Warning
bold_red='\033[1;31m'
reset='\033[0m'
echo -e "${bold_red}Это версия скрипта более не поддерживается, новая версия в репозитарии https://github.com/IndeecFOX/zapret4rocket
Скрипт новой версии:
curl -O https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/z4r.sh && bash z4r.sh && rm z4r.sh${reset}"

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

#pre
opkg update
opkg install unzip
opkg install git-http

#directories
cd /
mkdir opt
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
wget -O zapret-v71.1.zip "https://github.com/bol-van/zapret/releases/download/v71.1/zapret-v71.1.zip"
unzip zapret-v71.1.zip
rm -f zapret-v71.1.zip
mv zapret-v71.1 zapret

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
sh zapret/install_bin.sh
sh zapret/install_prereq.sh
sh -i zapret/install_easy.sh
/etc/init.d/zapret restart
echo "zeefeer перезапущен и полностью установлен"
