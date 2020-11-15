#!/bin/bash
#
# PulseRTP-Multiroom
# <https://github.com/se-msys/pulsertp-multiroom> 
#
#   Loads RTP sender modules to setup multiroom-audio on request
#
#   Notes
#     * Never use Multicast on wireless networks, use unicast instead
#     * If you have multiple network interfaces, add source_ip= with you prefered local IP
#     * MTU 1408 is good initial value.
#
pa_rtp_mtu=1408
pa_sink="rtp1"

# kill running sessions
IFS=$'\n'
for rtpn in `pactl list modules short|grep module-rtp-send`; do
    PAM_ID=`echo $rtpn|awk '{print $1}'`
    pactl unload-module $PAM_ID
    echo " * unload-module id $PAM_ID"
done

# multicast
pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} source_ip=192.168.37.3

# unicast
#pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} destination=192.168.XXX.101
#pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} destination=192.168.XXX.102

