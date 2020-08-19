#!/bin/bash

# check for root privileges

if [ $(/usr/bin/id -u) -ne 0 ]; then
        echo "This script needs to be run as root.  Please try again using sudo."
        exit
fi

# Variable for backup directory
BACKUPDIR="backup-$(date +"%Y-%m-%d")"

# Create backup directories
mkdir -p $BACKUPDIR
mkdir -p $BACKUPDIR/logstash

# Copy files to backup directories
cp /etc/redis/redis.conf $BACKUPDIR
cp -av /etc/elasticsearch/elasticsearch.yml $BACKUPDIR
cp -av /etc/logstash/custom/* $BACKUPDIR/logstash
for i in $(ls /opt/zeek/share/zeek/policy/*-filter/*); do cp -av $i $BACKUPDIR ; done
cp -av /opt/zeek/share/zeek/site/local.zeek $BACKUPDIR
for i in $(cat /etc/nsm/sensortab | grep -v "#" | awk '{print $1}'); do
        mkdir -p $BACKUPDIR/$i
        cp -av $i /etc/nsm/$i/suricata.yaml $BACKUPDIR/$i
done
