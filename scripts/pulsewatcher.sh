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
ON_PLAYBACK="/opt/some-other-script-start.sh"
ON_SUSPEND="/opt/some-other-script-end.sh"

if [ -e /etc/openwrt_release ]; then
	LOGREAD="logread -f"
else
	LOGREAD="tail -f /var/log/syslog"
fi 

# follow syslog
$LOGREAD | while read line; do 
	pa_alsa_start=`echo $line|grep "alsa-sink.c: Starting playback"`
	pa_alsa_start_result=$?

	pa_alsa_stop=`echo $line|grep "alsa-sink.c: Device suspended"`
	pa_alsa_stop_result=$?

	if [ $pa_alsa_start_result -eq 0 ]; then
		echo "[pulseaudio] detected playback start"
		eval $ON_PLAYBACK &
	fi

	if [ $pa_alsa_stop_result -eq 0 ]; then
		echo "[pulseaudio] detected playback end"
		eval $ON_SUSPEND &
	fi

done

