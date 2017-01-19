Synchronized multiroom audio with PulseAudio RTP
================================================

This is a collection of scripts and example configuration to achieve syncronized multiroom audio with PulseAudio


Master
------

This is the sending node. It runs PulseAudio with the ***master*** "**sink**".

It can be any Linux system with enough juice to run PulseAudio and the desired clients. I run it on my Ubuntu home server, but a RPi2 or simmilar should do fine.


Receiver
--------

This is the receiving end. Running PulseAudio with one or more `rtp-recv` modules, depening on you want unicast or multicast audio. 
It builds up a buffer according to the specified latency, then it performs sample rate correction with the embedded timecode in the RTP stream.
It's very important that the ***Master*** and ***Receiver*** nodes have their system clocks syncronized, so running a local NTP on the Master is recommended.

***Note!*** It is recommended to use similar type of platform and soundcard for the receving devices.

See [OPENWRT.md](OPENWRT.md) how to setup a OpenWRT device to run as receiver.


Clients
-------

Client's can be any PulseAudio compatible application

### Example: Shairport

To make ***shairport*** launch multiroom streams at playback start, use the following command line example:

`shairport -o pulse -a MyAirPlayReceiverName -B /opt/pulsertp-multiroom/scripts/pulsertpm-start.sh -B /opt/pulsertp-multiroom/scripts/pulsertpm-stop.sh`

### Example: MPD

/etc/mpd.conf:

    audio_output {
        type        "pulse"
        name        "PulseAudio Output"
        server      "127.0.0.1"
    }
