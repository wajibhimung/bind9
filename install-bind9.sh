#!/bin/sh

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

#Konfigurasi

# Update packages and Upgrade system
echo -e "$Cyan \n Updating System.. $Color_Off"
sudo apt-get update -y && sudo apt-get upgrade -y

## Install Bind9
echo -e "$Cyan \n Installing Bind9 $Color_Off"
sudo apt install bind9 bind9utils bind9-doc -y

#Mulai konfigurasi bind
#Stop service bind
sudo systemctl stop bind9.service
#Backup named.conf.lokal
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bkp
#Hapus named.conf.local
sudo rm /etc/bind/named.conf.local
#Menyalin named.conf.local yang telah kita sesuaikan
sudo cp named.conf.local /etc/bind/named.conf.local

#Menyalin file forward
sudo cp forward /etc/bind/forward

#Menyalin file reverse
sudo cp reverse /etc/bind/reverse

#Menambahkan name server sesuaiakan ip server
echo nameserver 192.168.229.220 > /etc/resolv.conf

#Konfigurasi firewall
sudo ufw allow 53/tcp
sudo ufw enable
sudo ufw reload

#Restart bind
sudo systemctl restart bind9.service




