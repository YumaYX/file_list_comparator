#!/usr/bin/env sh

# as root

tstamp=$(date +%Y%m%d%H%M%S)

# /etc
find /etc | while read line
do
cksum ${line}
done > list_${tstamp}.txt

ls -d list_${tstamp}.txt
