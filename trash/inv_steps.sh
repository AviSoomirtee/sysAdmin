
cacert=0
proxy=0

functionn check_os () {
	if [ centos ]
	then
		echo "its a red hat"
		return 1
	else
		echo "its debian"
		return 0
	fi
}

function check_crt {
	if [ present ]
		return true
	else 
		return false
	fi
}

function add_crt () {

}

function check_proxy {
	if [ proxy present ]
	then
		Echo "proxy available"
		proxy=1
		return $proxy
	else
		proxy=2
		return false
	fi
}


function add_proxy (take proxy ) {
	do things to add proxy
}

function check_inv_cron () {
	get cron time
	if [ hour = 4 && min =23 ]
	then 
		set min1 =21
		set hr1 = hour

		set min2 = 46
		set hr2 = hour

		set min3 = 16
		set hr3 = 5

	elif [ hour = 0 && min = 6 ]
	then
		set min1 = 4
		set hr1 = hour

		set min2 = 16
		set hr2 = hour

		check time well
	else
		echo "no cron job found"
	fi
}

function set_cron (proxy,PROXY) {

if [ proxy ]
then 
	check_inv_cron ()
	do stuff to create cron for proxy
	cron="yes"
else
	echo "no cron added"
	cron="no"
fi
}

function run_inv () {
	
	if [ check_os='1' ]
	then 
		do stuff to run inventaire red hat
	else
		do stuff to run inventaire debian
	fi
}

function get_error () {

}

funtion get_log () {

}


function telnet_gate () {

do stuff to test gate flux

if [ gate open ]
then
	echo " Gate open."
	return 0 #true
else
	echo "Gate not open"
	return 1 #false
fi

}

######################################################### while should start here






############## checking if cacert is present #########

if [ check_crt () true ]
then
	echo "not needed"
	cacert=1
else
	echo "need cacert.pem"
	add_crt ()
	cacert=2
fi


################## checking log ######################

log = get_log ()

if [ -n log ]
then
	echo "log empty"
	run_inv ()
	log = get_log
	echo "here is the log"
	echo $log
else
	echo "here is the log"
	echo $log
fi

################ finding error ######################

ERRORR = get_error ()

if [ -n ERRORR ]
then
	echo "Theres no error"
else
	echo "Error found, here it is."
	echo $ERRORR
fi

################ Trying to correct the error ################

if [ error = cannot connect to gate ]
then
	if [ ! proxy = false ] && [ cacert = '2' ]
	then
		add_proxy ( check_proxy )
		run_inv ()
		if [ -n ERROR ]
		then
			echo "Solution needed proxy."
			solution="added proxy: $PROXY"
			echo "Cron will be added."
			set_cron ()
			good=true
		fi	
	else 
		echo "Theres no proxy, searching nexxt solution"
		if [ telnet_gate () = true ]
		then
			
		else
			echo "Gate close, need to open flux"
			action="do a demand to open flux to gate"
		fi
	fi
fi


########################################################### writing report

hostname |  dns     |      log     |     first_error        |           solution                   | cron  |      status        |       action
 myname  |  my.name |  current log | cannot connect to gate | proxy added: http://proxy-priv.bn.fr |  yes  | successful or fail | demand to open flux 


################################################################  close while loop
