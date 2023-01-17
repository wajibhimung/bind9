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

#Backup named.conf.option
sudo cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bkp
#Hapus named.conf.options 
sudo rm /etc/bind/named.conf.options 
#Menyalin named.conf.options  yang telah kita sesuaikan
sudo cp named.conf.options  /etc/bind/named.conf.options

#Menyalin file forward
sudo cp forward /etc/bind/forward

#Menyalin file reverse
sudo cp reverse /etc/bind/reverse

#Menambahkan name server sesuaiakan ip server
echo nameserver 192.168.25.220 > /etc/resolv.conf

#Konfigurasi firewall
sudo ufw allow 53/tcp
sudo ufw enable
sudo ufw reload

sudo iptables -I INPUT 1 -p tcp -m tcp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -I INPUT 2 -p udp -m udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT

#Restart bind
sudo systemctl restart bind9.service




