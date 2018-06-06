FROM debian:stretch-backports

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

# Add Docker SuperUser.
ARG admin_username=admin
ARG admin_password=admin
ARG admin_email=$admin_password@localhost.com
RUN /start.sh &&\
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('$admin_username', '$admin_email', '$admin_password')" | lava-server manage shell && \
	/stop.sh

# Register device-types and devices (populate script).
COPY config/device-types/*.jinja2 /etc/lava-server/dispatcher-config/device-types/
COPY config/devices/*.jinja2 /etc/lava-server/dispatcher-config/devices/
COPY scripts/populate.sh /
RUN /start.sh \
  && /populate.sh \
  && /stop.sh

CMD /start.sh && sleep infinity
