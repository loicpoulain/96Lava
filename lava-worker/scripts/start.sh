#!/bin/bash

service tftpd-hpa start # to retrieve kernel over network (e.g. with u-boot)
service ser2net start # expose tty port on network
service rpcbind start # for nfs < 3
service nfs-kernel-server start # for network rootfs (nfs)

MASTER_URL=tcp://localhost:5556
LOGGER_URL=tcp://localhost:5555
LOGLEVEL=DEBUG
. /etc/default/lava-slave
. /etc/lava-dispatcher/lava-slave

/lib/systemd/systemd-udevd & # Used to detect and add USB fastboot devices to LXC
/usr/bin/lava-slave --level $LOGLEVEL --master $MASTER_URL --socket-addr $LOGGER_URL --hostname $HOSTNAME
