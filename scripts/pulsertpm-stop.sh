#!/bin/bash
#
# PulseRTP-Multiroom
#   Unloads RTP sender modules to avoid unnecessary bandwidth hogging
#

IFS=$'\n'
for rtpn in `pactl list modules short|grep module-rtp-send`; do
    PAM_ID=`echo $rtpn|awk '{print $1}'`
    pactl unload-module $PAM_ID
    echo " * unload-module id $PAM_ID"
done
