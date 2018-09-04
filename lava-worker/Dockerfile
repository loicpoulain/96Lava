FROM debian:stretch-backports

# Update package list and upgrade
RUN apt -q update

# Install prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    wget \
    gnupg \
    apt-transport-https

# Add Linaro Lava repository to apt sources, Register auth key
RUN echo "deb https://images.validation.linaro.org/production-repo stretch-backports main" >> /etc/apt/sources.list.d/lava.list
RUN wget -qO - https://images.validation.linaro.org/staging-repo/staging-repo.key.asc | apt-key add -

# Add Linaro buster repository, some arm64 tools not available in standard source (e.g. simg2img)
RUN echo "deb http://obs.linaro.org/linaro-overlay-buster/buster/ ./" >> /etc/apt/sources.list.d/linaro.list
RUN wget -qO - http://obs.linaro.org/linaro-overlay-buster/buster/Release.key | apt-key add -

RUN apt -q update

# Install lava-dispatcher and required tools
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    lava-dispatcher \
    qemu-system \
    qemu-system-arm \
    qemu-system-i386 \
    e2fsprogs \
    tftpd-hpa \
    nfs-kernel-server \
    python-netifaces \
    simg2img \
    img2simg \
    microcom \
    python-pip && \
    pip install --pre -U pyocd

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
COPY patches /patches

# Apply patches
RUN find /patches -type f -name '*.patch' -print0 | xargs -0 cat | patch -F 50 -p1

RUN echo "MASTER_URL=\"tcp://lava-master:5556\"" >> /etc/lava-dispatcher/lava-slave
RUN echo "LOGGER_URL=\"tcp://lava-master:5555\"" >> /etc/lava-dispatcher/lava-slave

CMD /start.sh && sleep infinity
