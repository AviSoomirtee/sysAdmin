#!/bin/bash


CONF="/usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg"

HOST='uxfrlb-bckapp1p.sodexo.lbn.eq3.std.linkbynet.com'

BASH='execute.bash'
CMD='all_cmds.bash'

read PROXY <<<  $(sed -n 1p check_proxy.bash | ssh -t uxfrlb-bckapp1p.sodexo.lbn.eq3.std.linkbynet.com)
read PROXY <<<  $(sed -n 1p $CMD | ssh -t $HOST)

if [ -z "$PROXY" ]
then 
	echo "Proxy not available!"
else 
	echo "Proxy available"
	echo $PROXY
	echo "sudo -i" > $BASH
	echo "echo '$PROXY' >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg.example" >> $BASH
	echo "exit" >> $BASH
	echo "exit" >> $BASH
	#cat $BASH | ssh -t -t $HOST
	echo "Proxy added successfull" >> $HOST.txt
	echo "----" >> $HOST.txt
	echo "This is the proxy added: $PROXY" >>$HOST.txt
	
fi
