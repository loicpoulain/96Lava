#!/bin/bash

# Usage dragonboard-ftdi FTDI_SERIAL command
# commands: reset, reset-fastboot

if [ "$#" -ne 2 ]; then
	echo "usage: $0 <ftdi_serial> <reset|on|off>"
	exit -1
fi

# Find ftdi sysfs path
USB_DEVICES=$(find -L /sys/bus/usb/devices/ -maxdepth 3 -name "serial" 2> /dev/null)
for i in ${USB_DEVICES}; do
	SERIAL=$(cat $i)
	if [ ${SERIAL} = $1 ]; then
		FTDI=$(dirname "$i")
		break
	fi
done

if [ -z ${FTDI} ]; then
	echo "FTDI with serial '$1' not found!"
	exit 1
fi

echo "Found FTDI at ${FTDI}"

if [ "$2" = "connect" ]; then
	TTY=`find ${FTDI}/* -name ttyUSB* | tail -n1`
	TTY=`basename ${TTY}`
	microcom -p /dev/${TTY} -s 115200
	exit 0
fi

# Find base GPIO
GPIO_BASE=$(cat ${FTDI}/gpio/gpiochip*/base)

if [ -z ${GPIO_BASE} ]; then
	echo "No GPIO chip associated to the FTDI!"
	exit 1
fi

GPIO_POWER=${GPIO_BASE}
GPIO_RESET=$(expr ${GPIO_POWER} + 1)

echo "GPIO_POWER = ${GPIO_POWER}"
echo "GPIO_RESET = ${GPIO_RESET}"

if [ ! -e /sys/class/gpio/gpio${GPIO_POWER} ]; then
	echo "Exporting gpio${GPIO_POWER}"
	echo ${GPIO_POWER} > /sys/class/gpio/export
fi

if [ ! -e /sys/class/gpio/gpio${GPIO_RESET} ]; then
	echo "Exporting gpio${GPIO_RESET}"
	echo ${GPIO_RESET} > /sys/class/gpio/export
fi

echo "out" > /sys/class/gpio/gpio${GPIO_POWER}/direction
echo "out" > /sys/class/gpio/gpio${GPIO_RESET}/direction

GPIO_POWER=/sys/class/gpio/gpio${GPIO_POWER}/value
GPIO_RESET=/sys/class/gpio/gpio${GPIO_RESET}/value

if [ "$2" = "reset" ]; then
	echo 0 > ${GPIO_POWER}
	echo 0 > ${GPIO_RESET}
	sleep 1
	echo 1 > ${GPIO_POWER}
	echo 1 > ${GPIO_RESET}
elif [ "$2" = "off" ]; then
	echo 0 > ${GPIO_POWER}
	echo 0 > ${GPIO_RESET}
elif [ "$2" = "on" ]; then
	echo 1 > ${GPIO_POWER}
	echo 1 > ${GPIO_RESET}
fi
