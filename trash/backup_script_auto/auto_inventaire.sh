#!/bin/bash
#############################################################################################
######	This is an automated script made for correcting errors for Unix Inventory.	#####
######	The list of servers DNS and name should be placed in host.txt			#####
######	Logs will be created with output of errors if failed or with success.		#####
######	For any modification to this script please consult the author first.		#####
######  		Author: Diresh Soomirtee.					#####
#############################################################################################

CONF="/usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"
FILE="/var/lib/lbn-ocsinventory-agent/https:__gate.linkbynet.com_ec99b813fa064f7f7cfa1d35bc7cc3d743c61fd1_/cacert.pem"
#chk_file="[[ -f  "'/var/lib/lbn-ocsinventory-agent/https:__gate.linkbynet.com_ec99b813fa064f7f7cfa1d35bc7cc3d743c61fd1_/cacert.pem'" ]] ; echo $?"

STATE='0'
PROX_STATE='0'
SSL_STATE='0'
TRY='0'
EXIT='0'

#HOST='uxfrlb-bckapp1p.sodexo.lbn.eq3.std.linkbynet.com'
#HOST='lvmh-mhis-dynacollec01.lvmh.lbn.ie1.std.linkbynet.com'
#HOST="fdf-pp-bdd-02.fdf.lbn.ie1.std.linkbynet.com"
#HOST='fdf-bdd-02.fdf.lbn.ie1.std.linkbynet.com'
#HOST='lvmh-mhisdocker-pp-dock01.lvmh.lbn.ie1.std.linkbynet.com'
#HOST='uxfrlb-zabmon4p.sodexo.lbn.eq3.std.linkbynet.com'
#HOST='lvmh-chaumet-linbdd01.lvmh.lbn.ie1.std.linkbynet.com'
#HOST='zzxlbndc2ux.ppr.th2.par.linkbynet.com'
#HOST='edf-partage-web-01.edf.lbn.ie1.std.linkbynet.com'
#HOST='idg-jac-bdd-p-02.idgroup.lbn.ix1.aub.linkbynet.com'
#HOST='idg-jac-solr-p-01.idgroup.lbn.ix1.aub.linkbynet.com'
#HOST='pointpeco-bo-rct-1.outiz.lbn.ix1.aub.linkbynet.com'
#HOST='pcis-lvmhbdd1d.pcis.lbn.ie2.std.linkbynet.com'
#HOST='casyope-consult-p-01.casyope.lbn.ie2.std.linkbynet.com'
#HOST='pano-web1.panoranet.lbn.ie1.std.linkbynet.com'
#HOST='pano-web2.panoranet.lbn.ie1.std.linkbynet.com'
HOST='eram-prod-bdd01-adm.eram.lbn.ie2.std.linkbynet.com'

BASH='execute.bash'
CMD='all_cmds.bash'
CRT='add_crt.bash'
SSL_B='b_ssl.bash'

ERR_COM="Cannot establish communication : 500 Can't connect to gate.linkbynet.com:443 (connect: Connection timed out)"
ERR_COM2="Cannot establish communication : 500 Can't connect to gate.linkbynet.com:443"
ERR_COM3="Cannot establish communication : 500 Can't connect to gate.linkbynet.com:443 (connect: Connexion terminée par expiration du délai d'attente)"

ERR_SSL4="Cannot establish communication : 500 Can't connect to gate.linkbynet.com:443"
ERR_SSL="Cannot establish communication : 500 SSL_ca_file /var/lib/lbn-ocsinventory-agent/https:__gate.linkbynet.com_ec99b813fa064f7f7cfa1d35bc7cc3d743c61fd1_/cacert.pem does not exist"
ERR_SSL2="Cannot establish communication : 500 SSL_ca_file /var/lib/lbn-ocsinventory-agent/https:__gate.linkbynet.com_ec99b813fa064f7f7cfa1d35bc7cc3d743c61fd1_/cacert.pem can't be used: No such file or directory"
ERR_SSL3="Cannot establish communication : 500 SSL negotiation failed:"


function check_cacert {
	read ext_file <<< $(ssh $HOST [[ -f  "'/var/lib/lbn-ocsinventory-agent/https:__gate.linkbynet.com_ec99b813fa064f7f7cfa1d35bc7cc3d743c61fd1_/cacert.pem'" ]] ; echo $?)
	echo "Does file exists"
	echo $ext_file
	if [ "$ext_file" = '1' ]
	then
		echo "              "
		echo "Cacert.pem not found."
		echo "     "
		echo "Need to copy certificate."
		return 1
		#STATE='2'
	else 
		echo "Certificate Cacert.pem already exist."
		return 0
	fi
}

while [ ! $EXIT = '1' ]
do

	echo "****************************** Script starting *******************************"

	read PROXY <<<  $(sed -n 1p $CMD | ssh -t $HOST)
	read ERRORR <<< $(sed -n 2p $CMD | ssh -t $HOST)
	read ERRLOG <<<  $(sed -n 3p $CMD | ssh -t $HOST)

	echo "***************************** The log found **********************************"
	echo "  "
	echo $ERRLOG
	echo "  "
	echo "******************************************************************************"

	echo "   "
	echo "   "

	echo "************************* This is the ERROR in log ***************************"
	echo "   "
	if [ -z "$ERRORR" ]
	then
		echo "No errors found"
	else
		echo "******************* The error found **************************"
		echo $ERRORR
	fi

	echo "  "

	###################################################################################### Checking for the time Inventaire is running
	echo "***************************** Checking cron time *****************************"
	read MIN <<< $(sed -n 4p $CMD | ssh -t $HOST)

	sleep 2

	read HOUR <<< $(sed -n 5p $CMD | ssh -t $HOST)

	sleep 2

	echo "    "
	echo "    "

	echo "*************************** Inventaire running at $HOUR:$MIN ******************"

	#MIN="23"
	#HOUR="4"

	#######################################################################################  Setting the cron 2 min before inventaire is run
	if [ "$MIN" = "23" ]
	then 
		echo "  "
		echo "Cron for adding proxy will run at 4 21"
		MIN=21
	fi

	echo "   "

	#echo "$HOUR"
	#echo "$MIN"

	echo "*************************** Cron will be run at $HOUR:$MIN ******************"
	#echo "   "
	#echo "   "

	echo "*************************** Analyzing the error *********************************"
	echo "   "
	echo "$ERRORR"
	echo "    "
	echo "*********************************************************************************"
	echo "   "

	##############################################################  Checkiing if proxy is available
	if [ -z "$PROXY" ]
	then
		echo " "
		echo "Proxy not available"
	else
		echo " "
		echo "Proxy available"
		echo $PROXY
		PROX_STATE="1"
	fi

	#check_cacert

	###############################################################  Checking for communication errors
	if [ "$ERRORR" = "$ERR_COM3" ]
	then
		echo " "
		echo "Maybe need proxy"
		if [ "$PROX_STATE" = "1" ]
		then
			STATE='1'
		fi

	elif [ "$ERRORR" = "$ERR_COM2" ]
	then
		if [ check_cacert $1 ]
		then
			echo "Need ccacert.pem"
			STATE='2'
		else 
			echo "Maybe need proxy"
			if [ "$PROX_STATE" = "1" ]
			then
				STATE='1'
			fi
		fi

	#################################################################  Checking for cacert.pem
	elif [ "$ERRORR" = "$ERR_SSL" ] || [ "$ERRORR" = "$ERR_SSL2" ]
	then
		echo "   "
		echo "Checking if cacert.pem is present"
		if [ check_cacert $1 ]
		then
			echo "Need certificate"
			STATE='2'
		else echo "Certificate already exist."
		fi

	elif [ "$ERRORR" = "$ERR_SSL3" ] || [ "$ERRORR" = "$ERR_SSL4" ]
	then
		echo "   "
		echo "Checking if cacert.pem is present"
		if [ check_cacert $1 ]
		then
			echo "Need certificate"
			STATE='2'
		elif [ $TRY = '1' ]
		then 
			STATE='3'
		else echo "Certificate already exist."
		fi


	else
		echo "No errors were found."
	fi

	############################################################################## cases for a particular task to be executed for correcting the errors

	case $STATE in
		1)
			echo " "
			echo "Going to add proxy"
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
			echo "Proxy added successfull" >> $HOST.txt
			echo "----" >> $HOST.txt
			echo "This is the proxy added: $PROXY" >>$HOST.txt
			;;
		2)
			echo "Adding certificate"
			echo "Adding certificate" >> $HOST.txt
			#cat $CRT | ssh -t -t $HOST
			echo "Certificate successfully added."
			echo "Certificate successfully added." >>  $HOST.txt
			;;
		3)	
			echo "Need to bypass ssl"
			echo "Bypassing ssl negoticiation " >> $HOST.txt
			#cat $SSL_B | ssh -t -t $HOST
			echo "Done"
			;;
		0)
			echo "Nothing to do"
			;;

	esac

	echo "************************* Checking for log *********************************************"
	read RESULT <<<  $(sed -n 3p $CMD | ssh -t $HOST) 
	echo "************************  Here is the log **********************************************"
	echo "  "
	echo $RESULT
	echo "  "
	echo "****************************************************************************************"

	read ERRORR <<< $(sed -n 2p $CMD | ssh -t $HOST)
	sleep 1

	if [ -z "$ERRORR" ]
	then
		echo "************************************************************************************"
		echo  "  "
		echo "Completed successfully."
		STATE='0'
		EXIT='1'
		echo "Completed successfully." >> $HOST.txt
	else
		echo "  "
		TRY='1'
		echo "hmmmm... something went wrong."
		echo "hmmmm... something went wrong." >> $HOST.txt
	fi

	echo "   "
	echo "   "
	echo "************************************ Script Ended! **************************************"
done
