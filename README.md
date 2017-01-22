Synchronized multiroom audio with PulseAudio RTP
================================================

This is a collection of scripts and example configuration to achieve synchronized multiroom audio with [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/).

![pulsertp](https://raw.githubusercontent.com/mada3k/pulsertp-multiroom/master/pulsertp.png "Pulse RTP flow")


Master
------
This is the sending node. It runs PulseAudio with the __master__ "__sink__", and uses `rtp-send` module to transmit RTP audio on the network.

It can be any Linux system with enough juice to run PulseAudio and the desired clients. I run it on my Ubuntu home server, but a RaspberryPi 2 or similar should do fine.

__Note!__ Beware that running multicast audio over wireless networks will affect all your wireless devices, and will drain the battery on your mobile devices (they are forced to wake up and process packets)
I strongly recommend always using unicast mode when using wireless networks shared with other devices.


Receiver
--------
This is the receiving end. Running PulseAudio with one or more `rtp-recv` modules, depending on if you want unicast or multicast. 
It builds up a buffer according to the specified latency, then it performs sample rate correction with the embedded timecode in the RTP stream.
Thus is very important that the __Master__ and __Receiver__ nodes have their system clocks tightly synchronized. Running a local NTP service on the __Master__ is recommended.

__Note!__ It is recommended to use similar type of platform and soundcard for the receiving devices.

See [OPENWRT.md](OPENWRT.md) how to setup a OpenWRT device to run as receiver.


Clients
-------
A client can be any PulseAudio compatible application. You can also configure a soundcard input as source.


### Example: Shairport

To make __shairport__ launch multiroom streams at playback start, use the following command line example:

    shairport -o pulse -a MyAirPlayReceiverName -B /opt/pulsertp-multiroom/scripts/pulsertpm-start.sh -B /opt/pulsertp-multiroom/scripts/pulsertpm-stop.sh


### Example: MPD

[MPD](https://www.musicpd.org/) is a great tool for playback of local music on a NAS or home server.

__/etc/mpd.conf:__

    audio_output {
        type        "pulse"
        name        "PulseAudio Output"
    }
