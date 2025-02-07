#!!! Write: "opkg install bash" - First in SSH!!!
# opkg install bash && bash <(curl -Ls https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/fast_install_for_OWRT.sh)

opkg update
opkg install unzip
 opkg install curl

 cd /
 mkdir opt
cd /opt

wget -O zapret-v69.9.zip "https://github.com/bol-van/zapret/releases/download/v69.9/zapret-v69.9.zip"
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
 sleep 2
/etc/init.d/zapret restart
