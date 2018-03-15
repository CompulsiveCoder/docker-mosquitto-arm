#!/bin/bash

#if ( "$(docker images -q mosquitto-docker-rpi 2> /dev/null)" == "" ); then
#	echo "Container doesn't exist. Building it first."
#	echo ""
#	./build.sh
#fi

# Include "--volume /path/to/persistence:mosquitto_data" if you want to ensure message persistence at shutdown.

sudo docker run -d \
  --name=mosquitto \
	--volume $PWD/data:/mosquitto_data \
	-e MQTT_HOST=localhost \
	-e MQTT_CLIENTID=client1234 \
	-e MQTT_USERNAME=j \
	-e MQTT_PASSWORD=pass \
	-e MQTT_TOPIC=Test \
	-p 1883:1883 \
	mosquitto-docker-rpi
