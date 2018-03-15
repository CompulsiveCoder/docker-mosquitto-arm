# Credit: https://gitlab.com/baze/mosquitto-docker-rpi

FROM resin/rpi-raspbian
#FROM ubuntu

RUN apt-get update && apt-get install -y wget && apt-get install -y apt-utils

RUN wget --quiet http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
	apt-key add mosquitto-repo.gpg.key

WORKDIR /etc/apt/sources.list.d/

RUN wget --quiet http://repo.mosquitto.org/debian/mosquitto-jessie.list && \
	apt-get update && apt-get install -y mosquitto

ADD start_mosquitto.sh /
ADD mosquitto_basic.conf /
ADD mosquitto_mqtt_bridge.conf /
ADD mosquitto.userfile /

EXPOSE 1883

VOLUME /mosquitto_data

WORKDIR /

CMD /start_mosquitto.sh
