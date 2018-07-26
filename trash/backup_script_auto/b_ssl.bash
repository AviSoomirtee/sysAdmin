sudo -i
cd /usr/local/linkbynet/script/inventaire/etc
echo "ssl=0" >> ocsinventory-agent.cfg
cd /usr/local/linkbynet/script/inventaire
sh inventaire.sh --no-timer
exit
exit
