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

# multicast
#pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} format=s16be channels=2 rate=44100

# unicast
pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} format=s16be channels=2 rate=44100 destination=192.168.XXX.101
pactl load-module module-rtp-send source=${pa_sink}.monitor mtu=${pa_rtp_mtu} format=s16be channels=2 rate=44100 destination=192.168.XXX.102

