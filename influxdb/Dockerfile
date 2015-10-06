FROM ubuntu:14.04
MAINTAINER Tom Noonan II (thomas.noonan@corvisa.com)

# v0.9 CONFIG

RUN apt-get update && apt-get install -y wget

# Add user with specified UID/GID, see README
# https://github.com/influxdb/influxdb/blob/1daf665a1d5deb00d383e799274d98deb2449505/package.sh#L289
RUN groupadd -g 904 influxdb && useradd -u 904 -g 904 -M influxdb

#RUN cd /tmp && wget http://influxdb.s3.amazonaws.com/influxdb_0.9.4.1_amd64.deb && dpkg -i influxdb_0.9.4.1_amd64.deb
# Run nightly to get latest bugfixes missing from stable
RUN cd /tmp && wget https://s3.amazonaws.com/influxdb/influxdb_nightly_amd64.deb && dpkg -i influxdb_nightly_amd64.deb

# Install config
COPY files/etc /etc

ENV INFLUXD_OPTS=""
# INFLUXD_HOSTNAME is the hostname advertised for clustering
# A port can be appended, but it doesn't modify the meta listener from the configured value.
ENV INFLUXD_HOSTNAME=""

VOLUME /var/opt/influxdb
USER influxdb
EXPOSE 8083 8086 8088
# If INFLUXD_HOSTNAME is blank, use hostname -f.  Otherwise use what the user specified.
CMD /opt/influxdb/influxd -config=/etc/opt/influxdb/influxdb.conf -hostname=$(if [ -z "$INFLUXD_HOSTNAME" ]; then hostname -f; else echo "$INFLUXD_HOSTNAME"; fi) $INFLUXD_OPTS
