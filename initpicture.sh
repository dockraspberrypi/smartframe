#!/bin/bash

export DISPLAY=:0.0
sleep 30
CNT=`ls -l /home/pi/smartframe | wc -l`
if [ $CNT -ge 1 ]
then
   FILE=`ls -1 /home/pi/smartframe/*jpeg | head -1 `
   /usr/bin/feh -F -x -Y --scale-down --auto-zoom $FILE &
fi

