#!/bin/bash
set -x

DEV_DIR=/etc/lava-server/dispatcher-config/devices
worker=worker0

# Add Worker(s)
lava-server manage pipeline-worker --hostname ${worker}

# Add all device types
lava-server manage add-device-type '*'

for file in ${DEV_DIR}/*.jinja2; do
	type=`basename $file | cut -d_ -f1`
	device=`basename $file | cut -d. -f1`
	lava-server manage add-device --device-type ${type} --worker ${worker} ${device}
	lava-server manage device-dictionary --hostname ${device} --import ${file}
done
