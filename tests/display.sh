#!/bin/bash

TMP=/var/tmp

export DISPLAY=:0.0
# get id of current picture
CURRENTPIC=`ps -ef| grep feh | grep -v grep | awk '{print $2}'`

# display a new pic 
PIC=$TMP/picture.jpg
if [ $# -eq 1 ]
then 
  PIC=$TMP/$1
else 
  PIC=$TMP/picture.jpg
fi
feh -y -x --scale-down --auto-zoom $PIC &

# now kill old pic
sleep 1
if [ ! -z $CURRENTPIC ]
then
  echo kill $CURRENTPIC
  kill $CURRENTPIC
else
  echo not set
fi


