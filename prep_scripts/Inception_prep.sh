#!/bin/bash

#set -o allexport
#source "./.env"
#set +o allexport

#RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
PURPLE=`tput setaf 5`
#BLUE=`tput setaf 6`
RESET=`tput sgr0`

read -p "${GREEN}Do you want to ${PURPLE}Configure your host?${GREEN}:${YELLOW} [y/N]${RESET} " all
if [ "$all" = 'N' ] || [ "$all" = 'n' ]
then
exit 0
fi

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install	make \
						curl \
						lsb-release \
						ca-certificates \
						apt-transport-https \
						software-properties-common \
						hostsed -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
	sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) \
		signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
		https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce -y
sudo apt-get update
sudo apt-get install docker-compose docker-compose-plugin -y
sudo apt-get update
sudo rm -rf /var/lib/apt/lists/*

if [ -d "/home/$USER/data" ]; then \
	echo "/home/$USER/data already exists"; else \
	mkdir /home/$USER/data; \
	echo "data directory created successfully"; \
fi

if [ -d "/home/$USER/data/wp_files" ]; then \
	echo "/home/$USER/data/wp_files already exists"; else \
	mkdir /home/$USER/data/wp_files; \
	echo "wp_files directory created successfully"; \
fi

if [ -d "/home/$USER/data/wp_db" ]; then \
	echo "/home/$USER/data/wp_db already exists"; else \
	mkdir /home/$USER/data/wp_db; \
	echo "wp_db directory created successfully"; \
fi

## Check if $USER.42.fr is set as localhost in the host
#if [ `cat /etc/hosts | grep $USER.42.fr | wc -l` -eq 0 ] 
#then 
#	echo "$USER.42.fr		127.0.0.1" | sudo tee -a /etc/hosts
#fi