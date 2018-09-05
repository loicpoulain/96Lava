FROM debian:stretch-backports

RUN apt -q update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
	udhcpd \
	net-tools \
	rfkill \
	hostapd

ARG interface=""
ARG ssid="WIFI_TEST"
ARG channel="6"
ARG password="password"

ENV SSID=$ssid
ENV INTERFACE=$interface
ENV CHANNEL=$channel
ENV PASSWORD=$password

COPY start.sh /

CMD /start.sh
