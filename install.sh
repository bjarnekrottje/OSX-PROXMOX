#!/bin/bash

#########################################################################################################################
#
# Script: install
#
# https://luchina.com.br
#
#########################################################################################################################

clear

if [ -e /root/OSX-PROXMOX ]; then rm -rf /root/OSX-PROXMOX; fi;
if [ -e /etc/apt/sources.list.d/pve-enterprise.list ]; then rm -rf /etc/apt/sources.list.d/pve-enterprise.list; fi;
if [ -e /etc/apt/sources.list.d/ceph.list ]; then rm -rf /etc/apt/sources.list.d/ceph.list; fi;
# Is this better?
echo "Waiting to install OSX-PROXMOX..."
echo " "

apt update > /tmp/install-osx-proxmox.log 2>> /tmp/install-osx-proxmox.log

if [ $? -ne 0 ]
then 
	echo " "
	echo "Error with 'apt-get update' ..."
	echo "Trying to change /etc/apt/sources.list"
	echo " "
	# Always using a Brazilian server will not be fast...
 	# I suggest using the users home country, As it will always be faster.
 	Country=$(curl -s https://ipinfo.io/country | tr '[:upper:]' '[:lower:]')
	sed -i "s/ftp.$Country.debian.org/ftp.debian.org/g" /etc/apt/sources.list
		
	echo "Retrying 'apt-get update' ..."
	echo " "

	apt-get update >> /tmp/install-osx-proxmox.log 2>> /tmp/install-osx-proxmox.log
	
	if [ $? -ne 0 ]; then echo "Error with 'apt-get update' ..."; exit; fi		
fi

apt install git -y >> /tmp/install-osx-proxmox.log 2>> /tmp/install-osx-proxmox.log

git clone https://github.com/bjarnekrottje/OSX-PROXMOX-fix.git >> /tmp/install-osx-proxmox.log 2>> /tmp/install-osx-proxmox.log

if [ ! -e /root/OSX-PROXMOX ]; then mkdir -p /root/OSX-PROXMOX; fi;

/root/OSX-PROXMOX/setup
