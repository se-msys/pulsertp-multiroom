#!/bin/bash
#
# PulseRTP-multiroom
#   Loads RTP sender modules to setup multiroom audio at request
#
#   Notes
#     * If you have issues, and have multiple network interfaces, add source_ip= with you prefered local IP
#     * mtu=1408 is good initial value. It makes room for 352 PCM frames in 16/44.1k.
#
pa_rtp_mtu=1408
pa_sink="master"

# multicast
#pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu}

# unicast
pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} destination_ip=192.168.XXX.101
pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} destination_ip=192.168.XXX.102

