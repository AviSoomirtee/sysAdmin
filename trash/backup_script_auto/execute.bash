sudo -i
cd /etc/cron.d/
touch inventaire_proxy
echo '21 4 * * * root echo proxy = http://proxy-priv.lbn.fr:80 >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg'  >> inventaire_proxy 
cd 
echo 'proxy = http://proxy-priv.lbn.fr:80' >> /usr/local/linkbynet/script/inventaire/etc/ocsinventory-agent.cfg
cd /usr/local/linkbynet/script/inventaire/
sh inventaire.sh --no-timer
exit
exit
