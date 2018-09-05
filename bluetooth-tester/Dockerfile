FROM debian:stretch-backports

RUN apt -q update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
	rfkill \
	bluetooth

ARG interface="hci0"
ARG name="BT_TEST"

ENV INTERFACE=$interface
ENV NAME=$name

COPY start.sh /

CMD /start.sh
