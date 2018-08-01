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

function test_proxy () { #add proxy in agent and run inventaire/ when call add proxy next to it
	PROX =$1
	echo "Adding proxy to agent"
	echo "sudo -i" >> $BASH
	echo "cd /usr/local/linkbynet/script/inventaire/etc/" >> $BASH
	echo "echo $PROX >> sinventory-agent.cfg" >> $BASH
	echo "sh inventaire.sh --no-timer" >> $BASH
	echo "exit" >> $BASH
	echo "exit" >> $BASH
	cat $BASH | ssh -t -t $HOST
	echo " "
	echo "Proxy added and inventaire launched."
	echo " "
	echo "Verrifying error."
	
	read ERRORR <<< $(sed -n 2p $CMD | ssh -t $HOST)
	echo " "

	if [ -z "$ERRORR" ]
	then
		echo "Log successfull"
		return 0
	else
		echo "Task failed."
		return 1
	fi


}

function cron_job () {					#takes as argument 1:proxy 2:PROXY value or 1:ssl
	echo "Checking for cron job for inventaire "
	read MIN <<< $(sed -n 4p $CMD | ssh -t $HOST)
	sleep 2
	read HOUR <<< $(sed -n 5p $CMD | ssh -t $HOST)
	echo " "
	echo "Time acquired"
	echo "Inventaire running at: $HOUR $MIN"

	if [ $HOUR="4" ] && [ $MIN="23" ]
	then
		MIN1="22"
		MIN2="46"
		HOUR2="5"
		MIN3="16"
	elif [ $HOUR="0" ] && [ $MIN="6" ]
	then
		MIN1="5"
		MIN2="16"
		HOUR2="6"
		MIN3="46"
	else
		echo "Cronjob is set for an odd time."
	fi

	if [ $1="proxy" ]  #for proxy
	then
		if [ -z "$2" ] #value of proxy
		then
			echo "Taking proxy and creating cronjob."
			local PROXY=$2
			echo "sudo -i" > $BASH
			echo "cd /etc/cron.d/" >> $BASH
			echo "touch inventaire_proxy" >> $BASH
			
			TEMP_PROXY="$MIN1 $HOUR * * * root echo $PROXY"
			TEMP2_PROXY="$TEMP_PROXY >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"
			echo "echo '$TEMP2_PROXY'  >> inventaire_proxy " >> $BASH
			
			TEMP_PROXY1="$MIN2 $HOUR * * * root echo $PROXY"
			TEMP2_PROXY1="$TEMP_PROXY1 >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"
			echo "echo '$TEMP2_PROXY1'  >> inventaire_proxy " >> $BASH

			TEMP_PROXY2="$MIN3 $HOUR2 * * * root echo $PROXY"
			TEMP2_PROXY2="$TEMP_PROXY2 >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"
			echo "echo '$TEMP2_PROXY2'  >> inventaire_proxy " >> $BASH

			echo "exit" >> $BASH
			echo "exit" >> $BASH
			cat $BASH | ssh -t -t $HOST
			echo " "
			echo "Cron job added for proxy."
		fi
	elif [ $1="ssl" ] #for bypassing ssl
	then
		echo "Creating cron job for bypassing ssl"
		echo "sudo -i" > $BASH
		echo "cd /etc/cron.d/" >> $BASH
		echo "touch inventaire_ssl" >> $BASH

		TEMP_SSL= "$MIN1 $HOUR * * * root echo 'ssl=0' >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"
		echo "echo '$TEMP_SSL' >> inventaire_proxy " >> $BASH

		TEMP_SSL= "$MIN2 $HOUR * * * root echo 'ssl=0' >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"
		echo "echo '$TEMP_SSL' >> inventaire_proxy " >> $BASH

		TEMP_SSL= "$MIN3 $HOUR2 * * * root echo 'ssl=0' >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"
		echo "echo '$TEMP_SSL' >> inventaire_proxy " >> $BASH
	fi
}



echo "Scritp started."

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


