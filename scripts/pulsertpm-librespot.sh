#!/bin/bash
#
# PulseRTP-Multiroom - librespot
# <https://github.com/se-msys/pulsertp-multiroom>
#
#   This is a librespot specific handler to let Pulseaudio network streaming
#   to avoid unnecessary unload/load-modole on librespot track-changes, pauses and such.
#
#   On stop it spawns an auto-shutdown thread to shutdown RTP senders after a while
#   If playback is resumed within 60s, then the auto-shutdown is canceled.
#
#   Run librespot with --onevent pulsertpm-librespot.sh --emit-sink-events
#
scripts_path="${HOME}/bin"
lockfile="/tmp/pulsertpm-librespot.lock"


#
# On librespot "running" status
#
if [ "$SINK_STATUS" == "running" ]; then
    # check for lockfile
    if [ -e $lockfile ]; then
        kill -9 `cat $lockfile`
        rm -f $lockfile
        echo " * canceling timeout thread"
        exit 0
    fi

    # find running sessions
    IFS=$'\n'
    RTP_SENDER_FOUND=0
    for rtpn in `pactl list modules short|grep module-rtp-send`; do
        PAM_ID=`echo $rtpn|awk '{print $1}'`
        RTP_SENDER_FOUND=1
    done

    # if no multicast found, launch it
    if [ $RTP_SENDER_FOUND -eq 1 ]; then
        echo " * rtp sender session already active"
        exit 0
    fi

    # start
    ${scripts_path}/pulsertpm-start.sh

    # exit
    exit 0
fi


#
# On librespot "closed" status
#
if [ "$SINK_STATUS" == "closed" ]; then
    # launch autotimeout process
    ${scripts_path}/pulsertpm-timeout.sh &

    # exit
    exit 0
fi


