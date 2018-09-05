FROM debian:stretch-backports

RUN apt -q update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
	lighttpd \
	vsftpd

ARG port_http="80"
ENV PORT_HTTP=$port_http

ARG port_ftp="21"
ENV PORT_FTP=$port_ftp

ARG root="/wwwroot"
ENV ROOT=$root

COPY start.sh /

CMD /start.sh
