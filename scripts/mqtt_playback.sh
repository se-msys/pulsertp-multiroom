#!/bin/sh
#
# MQTT Playback on/off
# value 0/1 depends on your actial platform
#
MQTT_HOST="mqtt.local"
MQTT_TOPIC="/maudio/playback/all/set"
GPIO_VALUE="/sys/class/gpio/gpio16/value"

# listen for messages
echo "[$0] listening on topic \"$MQTT_TOPIC\""
mosquitto_sub -h $MQTT_HOST -t $MQTT_TOPIC | while read line; do
  if [ "$line" == "on" ]; then
    echo "[$0] playback on"
    echo 0 > $GPIO_VALUE
  fi

  if [ "$line" == "off" ]; then
    echo "[$0] playback off"
    echo 1 > $GPIO_VALUE
  fi
done
