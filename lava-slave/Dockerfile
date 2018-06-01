FROM debian:stretch-backports

RUN apt -q update && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    lava-dispatcher

RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    qemu-system \
    qemu-system-arm \
    qemu-system-i386 \
    e2fsprogs

COPY scripts/start.sh /
COPY scripts/stop.sh /
COPY scripts/db820c-init.sh /

RUN echo "MASTER_URL=\"tcp://lava-master:5556\"" >> /etc/lava-dispatcher/lava-slave
RUN echo "LOGGER_URL=\"tcp://lava-master:5555\"" >> /etc/lava-dispatcher/lava-slave

#CMD /start.sh && sleep infinity
CMD /db820c-init.sh && /start.sh && tail -f /var/log/lava-dispatcher/lava-slave.log
