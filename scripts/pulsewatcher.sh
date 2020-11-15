#!/bin/sh
#
# PulseWatcher
#   Watches syslog for Pulseaudio playback start/end
#   Useful for triggering GPIO outputs and such things
#
# Enable PulseAudio INFO-level syslog
# /etc/pulse/daemon.conf:
#   log-target = syslog
#   log-level = info
#
ON_PLAYBACK="echo 0 > /sys/class/gpio/gpio18/value"
ON_SUSPEND="echo 1 > /sys/class/gpio/gpio18/value"

if [ -e /etc/openwrt_release ]; then
	echo "[pulsewatcher] using openwrt logread"
	LOGREAD="logread -f"

elif [ -e /var/log/syslog ]; then
	echo "[pulsewatcher] using classic /var/log/syslog"
	LOGREAD="tail -f /var/log/syslog"
else
	echo "[pulsewatcher] using systemd journal"
	LOGREAD="sudo journalctl -n0 -f"
fi

# follow syslog
$LOGREAD | while read line; do
	pa_alsa_start=`echo $line|grep "alsa-sink.c: Starting playback"`
	pa_alsa_start_result=$?

	pa_alsa_stop=`echo $line|grep "alsa-sink.c: Device suspended"`
	pa_alsa_stop_result=$?

	if [ $pa_alsa_start_result -eq 0 ]; then
		echo "[pulsewatcher] detected playback start"
		eval $ON_PLAYBACK &
	fi

	if [ $pa_alsa_stop_result -eq 0 ]; then
		echo "[pulsewatcher] detected playback end"
		eval $ON_SUSPEND &
	fi

done

