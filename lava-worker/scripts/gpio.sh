#!/bin/sh

if [ "${2}" = "on" ]; then
	echo 0 > /dev/gpio${1}/value
else
	echo 1 > /dev/gpio${1}/value
fi

exit 0
