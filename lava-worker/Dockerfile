FROM debian:stretch-backports

RUN apt -q update && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    wget \
    gnupg \
    apt-transport-https

RUN echo "deb https://images.validation.linaro.org/production-repo stretch-backports main" >> /etc/apt/sources.list
RUN wget https://images.validation.linaro.org/staging-repo/staging-repo.key.asc \
    && apt-key add staging-repo.key.asc

RUN apt -q update && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    lava-dispatcher

# TODO clean me
COPY config/linaro.list /etc/apt/sources.list.d/
RUN wget -qO - http://obs.linaro.org/linaro-overlay-buster/buster/Release.key | apt-key add -
RUN apt -q update

RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    qemu-system \
    qemu-system-arm \
    qemu-system-i386 \
    e2fsprogs \
    tftpd-hpa \
    nfs-kernel-server \
    python-netifaces \
    simg2img \
    img2simg

RUN apt -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    python-pip && \
    pip install --pre -U pyocd

# Add board specific init script
ARG board=db820c
COPY scripts/$board-init.sh /

COPY scripts/start.sh /
COPY scripts/stop.sh /
COPY scripts/gpio.sh /
COPY config/tftpd-hpa /etc/default/tftpd-hpa
COPY config/ser2net.conf /etc/ser2net.conf
COPY config/lava-dispatcher-nfs.exports /etc/exports.d/lava-dispatcher-nfs.exports
COPY config/lava-dispatcher.conf /etc/lava-dispatcher/lava-dispatcher.conf
COPY config/lxc-net /etc/default/lxc-net
COPY config/lxc-default /etc/lxc/default.conf
COPY scripts/dragonboard-ftdi.sh /
COPY scripts/nitrogen-ftdi.sh /

RUN echo "MASTER_URL=\"tcp://lava-master:5556\"" >> /etc/lava-dispatcher/lava-slave
RUN echo "LOGGER_URL=\"tcp://lava-master:5555\"" >> /etc/lava-dispatcher/lava-slave

#CMD /start.sh && sleep infinity
CMD /db820c-init.sh && /start.sh && sleep infinity
