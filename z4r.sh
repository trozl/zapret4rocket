#!/bin/bash
#Команда установки curl -O https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/z4r.sh && bash z4r.sh && rm z4r.sh

set -e

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
    source /opt/etc/entware_release
    release=$ID
else
    echo "Не удалось определить ОС. Прекращение работы скрипта." >&2
    exit 1
fi
echo "OS: $release"

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
     systemctl restart 3proxy
 elif [[ "$clean_answer" == "MARZBAN" ]]; then
     echo "Установка Marzban"
     bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban.sh)" @ install
 else
     echo "Пропуск установки ПО туннелирования."
 fi

 #Запрос на подбор стратегий
 if [ -f "/opt/zapret/uninstall_easy.sh" ]; then
  read -p $'\033[33mПодобрать альтернативную стратегию? Укажите цифру или нажмите Enter для пропуска:\033[0m\n\033[32m1. YT (UDP QUIC)\n2. YT (TCP)\n3. RKN\n4. Добавить домен\nEnter для пропуска\033[0m ' answer
  clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]') # Удаляем лишние символы и пробелы, приводим к верхнему регистру

  if [[ -z "$clean_answer" ]]; then
      echo "Пропуск подбора альтернативной стратегии"

  elif [[ "$clean_answer" == "1" ]]; then
     echo "Режим подбора стратегии для YT (UDP QUIC) активирован"
     # Цикл от 1 до 8
     for i in {1..8}; do

         if [[ $i -ge 2 ]]; then
             prev=$((i - 1))
             echo -n > "/opt/zapret/extra_strats/UDP/YT/${prev}.txt"
         fi

         cp "/opt/zapret/extra_strats/UDP/YT/List.txt" "/opt/zapret/extra_strats/UDP/YT/${i}.txt"

         systemctl restart zapret

         echo "Стратегия номер $i активирована"

         read -p "Проверьте работоспособность в браузере и т.п. и дайте ответ: (\"Y\" - Сохранить стратегию, Enter - попробовать следующую): " answer
         clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

         if [[ "$clean_answer" == "Y" ]]; then
             echo "Стратегия $i сохранена. Выходим."
             exit 0
         fi
     done

     # После цикла
     echo -n > "/opt/zapret/extra_strats/UDP/YT/8.txt"
     echo "Перечень стратегий закончился. Мы испробовали всё"
     exit 0
	
  elif [[ "$clean_answer" == "2" ]]; then
     echo "Режим подбора стратегии для YT (TCP) активирован"
     # Цикл от 1 до 17
     for i in {1..17}; do

         if [[ $i -ge 2 ]]; then
             prev=$((i - 1))
             echo -n > "/opt/zapret/extra_strats/TCP/YT/${prev}.txt"
         fi

         cp "/opt/zapret/extra_strats/TCP/YT/List.txt" "/opt/zapret/extra_strats/TCP/YT/${i}.txt"

         systemctl restart zapret

         echo "Стратегия номер $i активирована"

         read -p "Проверьте работоспособность в браузере и т.п. и дайте ответ: (\"Y\" - Сохранить стратегию, Enter - попробовать следующую): " answer
         clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

         if [[ "$clean_answer" == "Y" ]]; then
             echo "Стратегия $i сохранена. Выходим."
             exit 0
         fi
     done

     # После цикла
     echo -n > "/opt/zapret/extra_strats/TCP/YT/17.txt"
     echo "Перечень стратегий закончился. Мы испробовали всё"
     exit 0
    
  elif [[ "$clean_answer" == "3" ]]; then
     echo "Режим подбора стратегии для листа РКН активирован"
     # Цикл от 1 до 17
     for i in {1..17}; do

         if [[ $i -ge 2 ]]; then
             prev=$((i - 1))
             echo -n > "/opt/zapret/extra_strats/TCP/RKN/${prev}.txt"
         fi

         cp "/opt/zapret/extra_strats/TCP/RKN/List.txt" "/opt/zapret/extra_strats/TCP/RKN/${i}.txt"

         systemctl restart zapret

         echo "Стратегия номер $i активирована"

         read -p "Проверьте работоспособность в браузере и т.п. и дайте ответ: (\"Y\" - Сохранить стратегию, Enter - попробовать следующую): " answer
         clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

         if [[ "$clean_answer" == "Y" ]]; then
             echo "Стратегия $i сохранена. Выходим."
             exit 0
         fi
     done

     # После цикла
     echo -n > "/opt/zapret/extra_strats/TCP/RKN/17.txt"
     echo "Перечень стратегий закончился. Мы испробовали всё"
     exit 0

  elif [[ "$clean_answer" == "4" ]]; then
     echo "Режим подбора стратегии для кастомного домена активирован"

	 read -p "Введите требуемый домен (Например: mydomain.com): " user_domain
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

         echo "Стратегия номер $i активирована"

         read -p "Проверьте работоспособность в браузере и т.п. и дайте ответ: (\"Y\" - Сохранить стратегию, Enter - попробовать следующую): " answer
         clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

         if [[ "$clean_answer" == "Y" ]]; then
			 echo -n > "/opt/zapret/extra_strats/TCP/temp/${i}.txt" #Очищаем temp
			 echo "$user_domain" > "/opt/zapret/extra_strats/TCP/User/${i}.txt" #Кидаем в юзерлист на постоянку в приоритет
			 cp "/opt/zapret/extra_strats/TCP/RKN/List.txt" "/opt/zapret/extra_strats/TCP/RKN/${emp}.txt" #Включить обратно общий лист
             echo "Стратегия $i сохранена. Выходим."
             exit 0
         fi
     done

     # После цикла
     echo -n > "/opt/zapret/extra_strats/TCP/temp/17.txt"
     echo "Перечень стратегий закончился. Мы испробовали всё"
     exit 0
 
  else
     echo "Пропуск подбора альтернативной стратегии"
  fi
 else
  echo "zapret не установлен, пропускаем скрипт подбора профиля"
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
}

WRT() {
 #Запрос на подбор стратегий
 if [ -f "/opt/zapret/uninstall_easy.sh" ]; then
  read -p $'\033[33mПодобрать альтернативную стратегию? Укажите цифру или нажмите Enter для пропуска:\033[0m\n\033[32m1. YT (UDP QUIC)\n2. YT (TCP)\n3. RKN\n4. Добавить домен\nEnter для пропуска\033[0m ' answer
  clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]') # Удаляем лишние символы и пробелы, приводим к верхнему регистру

  if [[ -z "$clean_answer" ]]; then
      echo "Пропуск подбора альтернативной стратегии"

  elif [[ "$clean_answer" == "1" ]]; then
     echo "Режим подбора стратегии для YT (UDP QUIC) активирован"
     # Цикл от 1 до 8
     for i in {1..8}; do

         if [[ $i -ge 2 ]]; then
             prev=$((i - 1))
             echo -n > "/opt/zapret/extra_strats/UDP/YT/${prev}.txt"
         fi

         cp "/opt/zapret/extra_strats/UDP/YT/List.txt" "/opt/zapret/extra_strats/UDP/YT/${i}.txt"

         /etc/init.d/zapret restart

         echo "Стратегия номер $i активирована"

         read -p "Проверьте работоспособность в браузере и т.п. и дайте ответ: (\"Y\" - Сохранить стратегию, Enter - попробовать следующую): " answer
         clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

         if [[ "$clean_answer" == "Y" ]]; then
             echo "Стратегия $i сохранена. Выходим."
             exit 0
         fi
     done

     # После цикла
     echo -n > "/opt/zapret/extra_strats/UDP/YT/8.txt"
     echo "Перечень стратегий закончился. Мы испробовали всё"
     exit 0
	
  elif [[ "$clean_answer" == "2" ]]; then
     echo "Режим подбора стратегии для YT (TCP) активирован"
     # Цикл от 1 до 17
     for i in {1..17}; do

         if [[ $i -ge 2 ]]; then
             prev=$((i - 1))
             echo -n > "/opt/zapret/extra_strats/TCP/YT/${prev}.txt"
         fi

         cp "/opt/zapret/extra_strats/TCP/YT/List.txt" "/opt/zapret/extra_strats/TCP/YT/${i}.txt"

         /etc/init.d/zapret restart

         echo "Стратегия номер $i активирована"

         read -p "Проверьте работоспособность в браузере и т.п. и дайте ответ: (\"Y\" - Сохранить стратегию, Enter - попробовать следующую): " answer
         clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

         if [[ "$clean_answer" == "Y" ]]; then
             echo "Стратегия $i сохранена. Выходим."
             exit 0
         fi
     done

     # После цикла
     echo -n > "/opt/zapret/extra_strats/TCP/YT/17.txt"
     echo "Перечень стратегий закончился. Мы испробовали всё"
     exit 0
    
  elif [[ "$clean_answer" == "3" ]]; then
     echo "Режим подбора стратегии для листа РКН активирован"
     # Цикл от 1 до 17
     for i in {1..17}; do

         if [[ $i -ge 2 ]]; then
             prev=$((i - 1))
             echo -n > "/opt/zapret/extra_strats/TCP/RKN/${prev}.txt"
         fi

         cp "/opt/zapret/extra_strats/TCP/RKN/List.txt" "/opt/zapret/extra_strats/TCP/RKN/${i}.txt"

         /etc/init.d/zapret restart

         echo "Стратегия номер $i активирована"

         read -p "Проверьте работоспособность в браузере и т.п. и дайте ответ: (\"Y\" - Сохранить стратегию, Enter - попробовать следующую): " answer
         clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

         if [[ "$clean_answer" == "Y" ]]; then
             echo "Стратегия $i сохранена. Выходим."
             exit 0
         fi
     done

     # После цикла
     echo -n > "/opt/zapret/extra_strats/TCP/RKN/17.txt"
     echo "Перечень стратегий закончился. Мы испробовали всё"
     exit 0

  elif [[ "$clean_answer" == "4" ]]; then
     echo "Режим подбора стратегии для кастомного домена активирован"

	 read -p "Введите требуемый домен (Например: mydomain.com): " user_domain
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

         /etc/init.d/zapret restart

         echo "Стратегия номер $i активирована"

         read -p "Проверьте работоспособность в браузере и т.п. и дайте ответ: (\"Y\" - Сохранить стратегию, Enter - попробовать следующую): " answer
         clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

         if [[ "$clean_answer" == "Y" ]]; then
			 echo -n > "/opt/zapret/extra_strats/TCP/temp/${i}.txt" #Очищаем temp
			 echo "$user_domain" > "/opt/zapret/extra_strats/TCP/User/${i}.txt" #Кидаем в юзерлист на постоянку в приоритет
			 cp "/opt/zapret/extra_strats/TCP/RKN/List.txt" "/opt/zapret/extra_strats/TCP/RKN/${emp}.txt" #Включить обратно общий лист
             echo "Стратегия $i сохранена. Выходим."
             exit 0
         fi
     done

     # После цикла
     echo -n > "/opt/zapret/extra_strats/TCP/temp/17.txt"
     echo "Перечень стратегий закончился. Мы испробовали всё"
     exit 0
 
  else
     echo "Пропуск подбора альтернативной стратегии"
  fi
 else
  echo "zapret не установлен, пропускаем скрипт подбора профиля"
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
 wget -O zapret-v71.1-openwrt-embedded.tar.gz "https://github.com/bol-van/zapret/releases/download/v71.1/zapret-v71.1-openwrt-embedded.tar.gz"
 tar -xzf zapret-v71.1-openwrt-embedded.tar.gz
 rm -f zapret-v71.1-openwrt-embedded.tar.gz
 tar -xf zapret-v71.1-openwrt-embedded.tar
 rm -f zapret-v71.1-openwrt-embedded.tar
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
}

#Запуск скрипта под нужную версию
if [[ "$release" == "ubuntu" || "$release" == "debian" ]]; then
    VPS
elif [[ "$release" == "openwrt" ]]; then
    WRT
elif [[ "$release" == "entware" ]]; then
    #Entware
    echo "Заготовка"
else
    echo "Для этой ОС нет подходящей функции."
fi
