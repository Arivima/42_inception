#!/bin/bash

if [ ! -d "/home/$USER/data" ];
then
    mkdir -p /home/$USER/data/wp_files /home/$USER/data/wp_db
fi

if [ `cat /etc/hosts | grep $USER.42.fr | wc -l` -eq 0 ];
then
	echo "127.0.0.1		$USER.42.fr" | sudo tee -a /etc/hosts
fi