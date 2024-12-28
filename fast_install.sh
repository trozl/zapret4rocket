#!/bin/bash
set -e

# Запрос на ввод
read -p "You want install 3x-ui panel? [Y/n] (Enter for: n): " answer

# Если пользователь вводит "y" или "Y" (или просто нажимает Enter), выполняем установку
if [[ -z "$answer" || "$answer" =~ ^[Yy]$ ]]; then
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

# Проверяем наличие файла zapret-v69.8.zip и выполняем скачивание архив, если отсутствует
if [ -f "zapret-v69.8.zip" ]; then
    echo "Файл zapret-v69.8.zip уже существует. Используем его."
else
    echo "Файл zapret-v69.8.zip не найден. Загружаем файл..."
    wget https://github.com/bol-van/zapret/releases/download/v69.8/zapret-v69.8.zip
fi

# Распаковка архива zapret 69.8
wget https://github.com/bol-van/zapret/releases/download/v69.8/zapret-v69.8.zip
unzip zapret-v69.8.zip
mv zapret-v69.8 zapret

#Включение обхода дискорда
cp /opt/zapret/init.d/custom.d.examples.linux/50-discord /opt/zapret/init.d/sysv/custom.d/

#Копирование нашего конфига на замену стандартному
wget -O config.default https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/master/config.default
mv config.default /opt/zapret/

# Запуск установочных скриптов
sh zapret/install_bin.sh
sh zapret/install_prereq.sh
sh -i zapret/install_easy.sh
