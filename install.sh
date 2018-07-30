#!/bin/bash

echo "Copying configuration files..."

# Auto symlink creation on ttyUSB detection
cp host-conf/42-tty.rules /etc/udev/rules.d/

# Use dnsmasq as local dns resolver
cp host-conf/NetworkManager.conf /etc/NetworkManager/

# Ensure dnsmasq can be concurrently run inside containers on diff ifaces
cp host-conf/lxc /etc/dnsmasq.d/

# Add docker package server
cp host-conf/docker.list /etc/apt/sources.list.d/

echo "Installing docker..."
# Install docker
if [ -z $(which docker) ]; then
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	apt-get update
	apt-get install -y docker-ce
else
	echo "docker already installed"
fi

echo "Installing docker-compose..."
if [ -z $(which docker-compose) ]; then
	 apt-get install -y docker-compose
else
	echo "docker-compose already installed"
fi

echo "Building containers"
docker-compose build
