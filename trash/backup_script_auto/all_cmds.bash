grep "proxy" /etc/yum.repos.d/lbn.repo | uniq
tail /usr/local/linkbynet/script/inventaire/log/inventaire.log | grep "error" | cut -d] -f3
tail /usr/local/linkbynet/script/inventaire/log/inventaire.log
cat /etc/cron.d/lbn-puppet | grep "inventaire.sh" | cut -c 1-3
cat /etc/cron.d/lbn-puppet | grep "inventaire.sh" | cut -c 4-5
