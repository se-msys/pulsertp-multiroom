#!/bin/bash
#
# PulseRTP-multiroom
#   Loads RTP sender modules to setup multiroom audio at request
#
#   Notes
#     * If you have issues, and have multiple network interfaces, add source_ip= with you prefered local IP
#     * mtu=1408 is good initial value.
#
pa_rtp_mtu=1408
pa_sink="master"

# kill running sessions
IFS=$'\n'
for rtpn in `pactl list modules short|grep module-rtp-send`; do
    PAM_ID=`echo $rtpn|awk '{print $1}'`
    pactl unload-module $PAM_ID
    echo " * unload-module id $PAM_ID"
done

# multicast
#pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} format=s16be channels=2 rate=44100

# unicast
pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} format=s16be channels=2 rate=44100 destination=192.168.XXX.101
pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} format=s16be channels=2 rate=44100 destination=192.168.XXX.102

