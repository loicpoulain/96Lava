#!/bin/bash

set -e
set -x

rfkill unblock bluetooth
sleep 1

hciconfig ${INTERFACE} down
hciconfig ${INTERFACE} up
hciconfig ${INTERFACE} noleadv
hciconfig ${INTERFACE} name ${NAME}
hciconfig ${INTERFACE} leadv

sleep infinity
