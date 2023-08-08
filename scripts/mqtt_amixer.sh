#!/bin/sh
#
# MQTT Volume set
#
RTP_SINK="rtp"
MQTT_HOST="mqtt.local"
MQTT_TOPIC="/maudio/volume/57/set"
ALSA_MIXER="PCM"

# listen for messages
echo "[$0] listening on topic \"$MQTT_TOPIC\""
mosquitto_sub -h $MQTT_HOST -t $MQTT_TOPIC | while read line; do
  amixer set ${ALSA_MIXER} ${line}% >/dev/null
  echo "[$0] volume for ${ALSA_MIXER} set to ${line}"
done

