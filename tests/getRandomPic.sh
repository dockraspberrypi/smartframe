#!/bin/bash

TMP=/var/tmp

# collect a list of subdirectories
DIRS=`dbxcli ls -l | grep -v \
	Path | sed 's/^.*\///g'`
for single in $DIRS
do 
  # gather files for one of the directories
  FILES=`dbxcli ls -l $single | grep -v \
	Path | sed 's/^.* \///g'`

  # collect all files together
  TOTALFILES=`echo $TOTALFILES $FILES`
done

# convert files into an array
myArray=($TOTALFILES)

# total items in the array
cnt=${#myArray[@]}

# calculate a random # between 0 - count
idx=$(( $RANDOM % $cnt ))

dbxcli get ${myArray[$idx]} $TMP/picture.jpg
