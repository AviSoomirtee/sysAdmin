#!/bin/bash

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
