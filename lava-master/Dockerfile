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

# Install django
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    python-django python-django-tables2 wget whiptail gnupg \
    postgresql

# Install lava-server (django needs to be running)
RUN service postgresql start && \
    DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    lava-server

RUN a2dissite 000-default && \
	a2enmod proxy && \
	a2enmod proxy_http && \
	a2ensite lava-server.conf

# Start and Stop Lava master services scripts
COPY scripts/start.sh /
COPY scripts/stop.sh /

# init.d
COPY scripts/lava-master.init /etc/init.d/lava-server
COPY scripts/lava-publisher.init /etc/init.d/lava-publisher
COPY scripts/lava-logs.init /etc/init.d/lava-logs
COPY scripts/lava-server-gunicorn.init /etc/init.d/lava-server-gunicorn
COPY config/settings.conf /etc/lava-server/

# Add Docker SuperUser.
ARG admin_username=root
ARG admin_password=password
ARG admin_email=$admin_password@localhost.com
RUN /start.sh &&\
	lava-server manage users add $admin_username --passwd $admin_password --email $admin_email --superuser &&\
	/stop.sh

# Register device-types and devices (populate script).
COPY config/device-types/*.jinja2 /etc/lava-server/dispatcher-config/device-types/
COPY config/devices/*.jinja2 /etc/lava-server/dispatcher-config/devices/
COPY scripts/populate.sh /
RUN /start.sh \
  && /populate.sh \
  && /stop.sh

CMD /start.sh && sleep infinity
