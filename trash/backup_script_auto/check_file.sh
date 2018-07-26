#!/bin/bash
#file="/.config/backup.cfg"
#file="/home/avi/Desktop/lbn/https/cacert.pem"


file= "/var/lib/lbn-ocsinventory-agent/https:__gate.linkbynet.com_ec99b813fa064f7f7cfa1d35bc7cc3d743c61fd1_"

if [ ! -f "$file" ]
then
    echo "$0: File '${file}' not found."
else echo "File found!"
fi

