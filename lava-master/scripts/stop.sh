#!/bin/bash

service postgresql stop
service apache2 stop
service lava-logs stop
service lava-publisher stop
service lava-server-gunicorn stop
service lava-master stop
