PulseAudio RTP receiver on OpenWRT
==================================

I good advice in general is to use similar platforms and audio-interfaces. I use Atheros AR71xx-based with PCM2704 USB audio.
If possible, run a NTP service on the sender/master node, to make sure the sender and receiver have as synchronized system clock as possible.

* Configure networking for your needs on the new node. This is a simple "client node" setup I use for a GL.Inet "3G-Router"

__/etc/config/network:__

    config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

    config interface 'eth0'
        option ifname 'eth0'
        option proto 'dhcp'

    config interface 'wlan0'
        option ifname 'wlan0'
        option proto 'dhcp'

* Configure NTP     

__/etc/config/system:__

    config system
        option hostname MyReceiverName
        option timezone UTC
    
    config timeserver ntp
        list server ip.to.ntp.or.sender.node
        option enabled 1
        option enable_server 0

* Get the OpenWRT Imagebuilder for your platform.

* Build a image with needed packages. You also might want to skip some firewall/router-related packages to conserve flash.

`make image PACKAGES="-dnsmasq -iptables -ip6tables -ppp -kmod-ppp -ppp-mod-pppoe -kmod-pppox -kmod-nf-nathelper -firewall -odhcpd -odhcp6c -swconfig kmod-usb2 kmod-usb-audio alsa-lib alsa-utils libstdcpp pulseaudio-daemon pulseaudio-profiles pulseaudio-tools"`

* Transfer new firmware to device

`scp bin/ar71xx/openwrt-15.05.1-ar71xx-generic-*-squashfs-sysupgrade.bin 192.168.xxx.xxx:/tmp/`

* Login to current system and perform sysupgrade with the file you just uploaded. Device will reboot when done.

`sysupgrade /tmp/openwrt...`

* Use the following minimal configuration for PulseAudio

__/etc/pulse/system.pa:__

    #!/usr/bin/pulseaudio -nF
    load-module module-switch-on-port-available
    load-module module-alsa-sink device=hw:0,0 sink_name=alsahw0 rate=48000
    load-module module-native-protocol-unix
    load-module module-suspend-on-idle

    # set output sink
    set-default-sink alsahw0

    # rtp receive
    #load-module module-rtp-recv latency_msec=1000 sap_address=224.0.0.56
    load-module module-rtp-recv latency_msec=1000 sap_address=192.168.xxx.xxx      # for unicast


__/etc/pulse/daemon.conf__

    high-priority = yes
    nice-level = -11
    log-target = syslog
    log-level = info


__Note!__ `latency_msec` might need some individual adjustment. For example I use 1000ms on a wired node, but 1002ms on a wireless, since the wireless seems to introduce ~2ms of latency.
    
* Make sure that PulseAudio starts 

`/etc/init.d/pulseaudio enable`

`/etc/init.d/pulseaudio start`

