#!/bin/bash

cp root/checknet.sh /root
chmod 755 /root/checknet.sh 
cat root/crontab.root >> /var/spool/cron/crontabs/root
