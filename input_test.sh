#!/bin/bash

echo "Првоерка локали"
locale
echo "если где-то стоит C, POSIX, ru_RU.CP1251 или что-то не UTF-8 это может быть источником бага."

echo "Способ 1"
read -p "Введите домен (например, mydomain.com): " user_domain
user_domain=$(echo "$user_domain" | tr -d '[:space:]')
echo "Введён домен: $user_domain"

echo "Способ 2"
read -p "Введите домен (например, mydomain.com): " user_domain
echo "Введён домен: $user_domain"

echo "Способ 3"
read -r -p "Введите домен (например, mydomain.com): " user_domain
echo "Введён домен: $user_domain"

echo "Способ 4"
read -re -p "Введите домен (например, mydomain.com): " user_domain
echo "Введён домен: $user_domain"

echo "Отладочный тест"
read -r -p "Вставьте домен: " d
echo "HEX: $(echo -n "$d" | xxd)"
echo "TEXT: $d"
echo "должно быть: 77 68 61 74 73 61 70 2e 63 6f 6d whatsapp.com"

echo "Способ 5 RAW"
IFS= read -r -p "Введите домен: " user_domain
echo "Введён домен: $user_domain"

echo "Способ 6"
read -re -p "Введите домен (например, mydomain.com): " user_domain
user_domain=$(echo "$user_domain" | tr -d '\r\n[:cntrl:]')
echo "Введён домен: $user_domain"
