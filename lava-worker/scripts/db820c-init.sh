#!/bin/bash

# Initialize all 96boards LS GPIOs

db820c_gpios=( 80 29 124 24 62 507 10 8 25 26 23 133)
ls_gpios=( 23 24 25 26 27 28 29 30 31 32 33 34)

i=0
for gpio in ${db820c_gpios[@]}; do
	echo ${gpio} > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio${gpio}/direction
	echo 0 > /sys/class/gpio/gpio${gpio}/value
	chmod o+w /sys/class/gpio/gpio${gpio}/value
	ln -s /sys/class/gpio/gpio${gpio} /dev/gpio${ls_gpios[${i}]}
	i=$(($i+1))
done
