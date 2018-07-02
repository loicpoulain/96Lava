#!/bin/bash

postgres-ready () {
	echo "Waiting for lavaserver database to be active"
	while (( $(ps -ef | grep -v grep | grep postgres | grep lavaserver | wc -l) == 0 )); do
		echo -n "."
		sleep 1
		/usr/bin/lava-server manage --instance-template=/etc/lava-server/{filename}.conf lava-master --level DEBUG &
	done
	echo
	echo "[ ok ] LAVA server ready"
}

start () {
	echo "Start $1"
	if (( $(ps -ef | grep -v grep | grep -v add_device | grep -v dispatcher-config | grep "$1" | wc -l) > 0 ))
	then
		echo "$1 appears to be running"
	else
		service "$1" start
	fi
}

start postgresql
start apache2
start lava-publisher
start lava-server-gunicorn
#service lava-server start

LOGLEVEL=DEBUG
. /etc/default/lava-logs
. /etc/lava-server/lava-logs
/usr/bin/lava-server manage lava-logs --level $LOGLEVEL $SOCKET $MASTER_SOCKET $IPV6 $ENCRYPT $MASTER_CERT $SLAVES_CERTS &

postgres-ready
