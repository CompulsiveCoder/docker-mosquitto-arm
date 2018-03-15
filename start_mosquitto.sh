#!/bin/bash

# If MQTT defined we use Bridge configuration
if [ -z ${MQTT_HOST} ]; then
	echo "MQTT_HOST not defined. Running without bridge."
        cp mosquitto_basic.conf /etc/mosquitto/mosquitto.conf
else
	if [ -z ${MQTT_CLIENTID} ]; then echo "Variable MQTT_CLIENTID not set. Just select random value."; exit; fi
	if [ -z ${MQTT_USERNAME} ]; then echo "Variable MQTT_USERNAME not set."; exit; fi
	if [ -z ${MQTT_PASSWORD} ]; then echo "Variable MQTT_PASSWORD not set."; exit; fi
	if [ -z ${MQTT_TOPIC} ]; then echo "Variable MQTT_TOPIC not set."; exit; fi

        cp mosquitto_mqtt_bridge.conf /etc/mosquitto/mosquitto.conf
fi

# Search and replace variables
sed -i "s/<MQTT_HOST>/${MQTT_HOST}/g" /etc/mosquitto/mosquitto.conf
sed -i "s/<MQTT_CLIENTID>/${MQTT_CLIENTID}/g" /etc/mosquitto/mosquitto.conf
sed -i "s/<MQTT_USERNAME>/${MQTT_USERNAME}/g" /etc/mosquitto/mosquitto.conf
sed -i "s/<MQTT_PASSWORD>/${MQTT_PASSWORD}/g" /etc/mosquitto/mosquitto.conf
sed -i "s/<MQTT_TOPIC>/${MQTT_TOPIC}/g" /etc/mosquitto/mosquitto.conf

if [ -z ${MQTT_LOGIN_USERNAME} ]; then
	echo "MQTT_LOGIN_USERNAME not set. Running broger without login credentials. This is unsecure."
else
	echo "Setting MQTT login credentials."
        cp mosquitto.userfile /etc/mosquitto/mosquitto.userfile

	# Set MQTT login password
	sed -i "s/<MQTT_LOGIN_USERNAME>/${MQTT_LOGIN_USERNAME}/g" /etc/mosquitto/mosquitto.userfile
	sed -i "s/<MQTT_LOGIN_PASSWORD>/${MQTT_LOGIN_PASSWORD}/g" /etc/mosquitto/mosquitto.userfile
	mosquitto_passwd -U /etc/mosquitto/mosquitto.userfile

	# Modify configure to allow only logged in users.
	echo "allow_anonymous false" >> /etc/mosquitto/mosquitto.conf
	echo "password_file /etc/mosquitto/mosquitto.userfile" >> /etc/mosquitto/mosquitto.conf

fi


echo "Starting Mosquitto Broker"
/usr/sbin/mosquitto -h | head -1

echo ""
echo "---Using this configuration ---"
cat /etc/mosquitto/mosquitto.conf
echo "-------------------------------"
echo ""

/usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf

