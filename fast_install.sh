#!/bin/bash
set -e

#!/bin/bash

#Запрос на установку 3x-ui
read -p "Do you want to install the 3x-ui panel? (Y/N, Enter for N): " answer
# Удаляем лишние символы и пробелы, приводим к верхнему регистру
clean_answer=$(echo "$answer" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')
if [[ -z "$clean_answer" ]]; then
    echo "Skipping 3x-ui panel installation (default action)."
elif [[ "$clean_answer" == "Y" ]]; then
    echo "Installing 3x-ui panel..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
else
    echo "Skipping 3x-ui panel installation."
fi

# Обновление пакетов и установка unzip
apt update && apt install -y unzip

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

# Проверяем наличие файла zip и выполняем скачивание архив, если отсутствует
if [ -f "zapret-v69.9.zip" ]; then
    echo "Файл zip уже существует. Используем его."
else
    echo "Файл zip не найден. Загружаем файл..."
    wget https://github.com/bol-van/zapret/releases/download/v69.9/zapret-v69.9.zip
fi

# Распаковка архива zapret и его удаление
wget https://github.com/bol-van/zapret/releases/download/v69.9/zapret-v69.9.zip
unzip zapret-v69.9.zip
rm -f zapret-v69.9.zip
mv zapret-v69.9 zapret

#Включение обхода дискорда
cp /opt/zapret/init.d/custom.d.examples.linux/50-discord /opt/zapret/init.d/sysv/custom.d/

#Копирование нашего конфига на замену стандартному
wget -O config.default https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/master/config.default
mv config.default /opt/zapret/

# Запуск установочных скриптов
sh zapret/install_bin.sh
sh zapret/install_prereq.sh
sh -i zapret/install_easy.sh

# Перезагрузка zapret с помощью systemd
echo "Перезагружаем zapret..."
sleep 2
systemctl restart zapret
