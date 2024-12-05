#!/bin/bash
set -e

# Обновление пакетов и установка unzip
apt update && apt install -y unzip

# Переход в директорию /opt
cd /opt

# Скачивание и распаковка архива
wget https://github.com/IndeecFOX/zapret4rocket/releases/download/Z4R/zapret.zip
unzip zapret.zip

# Установка прав на выполнение
#find zapret/* -type f -exec chmod +x {} \;

# Запуск установочных скриптов
sh zapret/install_bin.sh
sh zapret/install_prereq.sh
sh -i zapret/install_easy.sh

# Перезапуск сервиса zapret
zapret/init.d/sysv/zapret restart
