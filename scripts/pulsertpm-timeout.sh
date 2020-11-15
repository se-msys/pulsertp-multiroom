#!/bin/bash
#
# PulseRTP-Multiroom - Auto-shutdown process
# <https://github.com/se-msys/pulsertp-multiroom> 
#
lockfile="/tmp/pulsertpm-librespot.lock"

# save this pid
echo $$ >$lockfile

# sleep
sleep 60

# unload modules
IFS=$'\n'
for rtpn in `pactl list modules short|grep module-rtp-send`; do
    PAM_ID=`echo $rtpn|awk '{print $1}'`
    pactl unload-module $PAM_ID
    echo " * unload-module id $PAM_ID"
done

# remove lock
rm -f $lockfile

# exit
exit 0
