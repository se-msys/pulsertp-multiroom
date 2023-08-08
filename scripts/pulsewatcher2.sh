#!/bin/sh
#
# PulseWatcher 2
#   Watches syslog for Pulseaudio playback start/end
#   then publish events to a common MQTT topic
#
# Enable PulseAudio INFO-level syslog
# /etc/pulse/daemon.conf:
#   log-target = syslog
#   log-level = info
#
MQTT_HOST="mqtt.local"
MQTT_TOPIC="/maudio/playback/all/set"

# listen for messages
echo "[$0] monitoring pulseaudio syslog"
sudo tail -n0 -f /var/log/syslog | while read line; do

  if [ $(echo $line|grep -Ec "pulseaudio.+Sink rtp idle for too long, suspending") -eq 1 ]; then
    echo "[$0] suspending playback"
    mosquitto_pub -h ${MQTT_HOST} -t ${MQTT_TOPIC} -m "off"
  fi

  if [ $(echo $line|grep -Ec "pulseaudio.+All sinks and sources are suspended") -eq 1 ]; then
    echo "[$0] suspending playback"
    mosquitto_pub -h ${MQTT_HOST} -t ${MQTT_TOPIC} -m "off"
  fi

  if [ $(echo $line|grep -Ec "pulseaudio.+Created input") -eq 1 ]; then
    echo "[$0] starting playback"
    mosquitto_pub -h ${MQTT_HOST} -t ${MQTT_TOPIC} -m "on"
  fi

done
