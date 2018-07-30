#!/bin/bash


HOST=''

function check_os () {
	
}

function check_crt () {

	read ext_file <<< $(ssh $HOST [[ -f  "'/var/lib/lbn-ocsinventory-agent/https:__gate.linkbynet.com_ec99b813fa064f7f7cfa1d35bc7cc3d743c61fd1_/cacert.pem'" ]] ; echo $?)
	#echo $ext_file   #0 if found 1 if not found
	if [ $ext_file ='0' ]
	then
		echo "Cacert.pem exist."
		return 0
	else
		echo "Cacert.pem not found."
		return 1
	fi
}

function add_crt () {
	echo "Addding Certificate"
	cat $CRT | ssh -t -t $HOST
	echo "Certificate successfully added."
}

function check_proxy {
	read PROXY <<<  $(sed -n 1p $CMD | ssh -t $HOST)
	if [ -z "$PROXY" ]
	then
		echo " "
		echo "Proxy not available."
		return 1
	else
		echo " "
		echo "Proxy available: " $PROXY
		proxy=1
		return $PROXY
	fi
}


function add_proxy () {
	proXy=$1
	echo "Adding proxy..."
	echo "sudo -i" > $BASH
	echo "cd /etc/cron.d/" >> $BASH
	echo "touch inventaire_proxy" >> $BASH
	TEMP_PROXY="$MIN $HOUR * * * root echo $PROXY"
	TEMP2_PROXY="$TEMP_PROXY >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"
	echo "echo '$TEMP2_PROXY'  >> inventaire_proxy " >> $BASH
	echo "cd " >> $BASH
	echo "echo '$PROXY' >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg" >> $BASH
	echo "cd /usr/local/linkbynet/script/inventaire/" >> $BASH
	echo "sh inventaire.sh --no-timer" >> $BASH
	echo "exit" >> $BASH
	echo "exit" >> $BASH
	cat $BASH | ssh -t -t $HOST
	
}




echo Scritp started.

usage () {

	echo "This script is used to automatically correct the inventory errors."
	echo " "
	echo "How to use it: "
	echo "	--run-all	will make the script loop through a list of servers from the host.txt file."
	echo "	--run <hostname>	will run only for this server"

}
echo  " "

if [ ! -z $1 ] && [ $1 = "--run-all" ]
then
	echo "Running by default"

elif [ ! -z $1 ] && [ $1 = "--run" ]
then
	if [ ! -z $2 ]
	then
		echo "This is the hostname: " $2
	else
		echo "Please add hostame"
	fi
else
	echo "You are using this script in the wrong way."
	usage
fi

#echo $2


