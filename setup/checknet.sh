#!/bin/bash
ping -c 1 8.8.8.8
if [ $? -ne 0 ] 
then
   echo restarting network >> /var/tmp/checknet.log
   echo `date `>>  /var/tmp/checknet.log
   /etc/init.d/networking restart
fi

