Synchronized multiroom audio with PulseAudio RTP
================================================

This is a collection of example scripts and configuration to achieve synchronized multiroom audio with [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/).

![pulsertp](https://raw.githubusercontent.com/mada3k/pulsertp-multiroom/master/pulsertp.png "Pulse RTP flow")


Master
------
This is the sending node. It runs PulseAudio with the __master__ "__sink__", and uses the `rtp-send` module to transmit RTP PCM audio over the network.

It can be any Linux system with enough juice to run PulseAudio and the desired playback applications. I run it on my Ubuntu home server, but a RaspberryPi 2 or better should do fine.

__Note!__ Beware that running multicast audio over wireless networks will *severly* affect all your wireless devices, and will drain the battery on your mobile devices (they are forced to wake up and process packets). I strongly recommend always using unicast-mode when using in wireless networks shared with other devices.

The script `pulsewatcher2.sh` tracks the syslog for PulseAudio playback start and RTP suspend messages, and publishes an event to all partipiciting receivers. This can be run as a systemd service.


Receiver
--------
This is the receiving end. Running PulseAudio with one `rtp-recv` module, depending on if you want unicast or multicast. 
It builds up a buffer according to the specified latency, then it performs sample rate correction with the embedded NTP timecode in the RTP stream.
Thus is very important that the __Master__ and __Receiver__ nodes have their system clocks tightly synchronized. Running a local NTP service on the __Master__ is recommended.

__Note!__ It is also recommended to use similar type of platform and soundcard for the receiving devices. Using mixed hardware setups will require you to manually calibrate the differences in latency.

See [OPENWRT.md](OPENWRT.md) how to setup a OpenWRT device to run as receiver.


Playback clients
----------------
A client can be any playback application with PulseAudio backend support, or can output PCM as a UNIX-pipe. You can also configure a soundcard input as source.

* [Shairport-sync](https://github.com/mikebrady/shairport-sync) - Apple® AirPlay™ compatible receiver
* [Librespot](https://github.com/librespot-org/librespot) - Spotify® Connect compatible player  
* [MPD](https://www.musicpd.org/) - Plays locally stored music headless


My setup
--------
I run the Master and playback applications on my Linux-based NAS/mini-server.

* Master runnning Ubuntu Linux on Intel N3150.
* Receiver on wired ethernet GL.inet AR150 running OpenWRT (PCM2704 USB-Audio to Class-D amp, relay-activated via GPIO)
* Receiver on wired ethernet Rasperry Pi 2 running Volumio (HifiBerry Digi HiFi S/PDIF to Recevier)
* Dedicated VLAN for Multicast Audio with higher QoS/CoS


Known issues
------------
* Sometimes when starting a stream, it __starts__ completly out of sync. Sometimes if finds itself in sync again after a few minutes, sometimes I don't.

* When running on wireless, and a sudden network dropout occurs, a severe out-of-sync occurs and the playback samplerate escalates. It will never find itself back in sync. Then it's just better to restart the streaming from scratch.

* After a while some crackling sound may introduce itself, but often it disappears of its own after a while. Might be USB-Audio related, or some buffert bug in PulseAudio, not sure.

* If using Multicast, either use a dedicated VLAN or make sure that IGMP Snooping works properly on your switches.



