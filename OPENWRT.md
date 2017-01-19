OpenWRT PulseRTP receiver
===========================

I general good advice is to use similar platforms and audio-interfaces. I use Atheros AR71xx-based with PCM2704 USB audio.
If possible, run a NTP service on the sender node, to make sure the sender and receiver have as syncronized clocks as possible.

1. Configure networking for your needs on the new node. This is a simple "client node" setup I use for a GL.Inet "3G-Router"

/etc/config/network:

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

5. Configure NTP     

/etc/config/system:
    config system
        option hostname MyReceiverName
        option timezone UTC

    config timeserver ntp
        list server ip.to.ntp.or.sender.node
        option enabled 1
        option enable_server 0

1. Get the OpenWRT Imagebuilder for your platform

2. Build a image with needed packages. You also might want to skip some firewall-related stuff to conserve flash.

    make image PACKAGES="-dnsmasq -iptables -ip6tables -ppp -kmod-ppp -ppp-mod-pppoe -kmod-pppox -kmod-nf-nathelper -firewall -odhcpd -odhcp6c -swconfig kmod-usb2 kmod-usb-audio alsa-lib alsa-utils libstdcpp pulseaudio-daemon pulseaudio-profiles pulseaudio-tools"

3. Login to current system. Transfer new firmware image to device and upgrade. Device will reboot when done.

    sysupgrade /tmp/openwrt...

4. Use the following minimal configuration for PulseAudio

/etc/pulse/system.pa:

    #!/usr/bin/pulseaudio -nF
    load-module module-switch-on-port-available
    load-module module-alsa-card device_id=0 sink_name=alsahw0 rate=48000
    load-module module-native-protocol-unix
    load-module module-suspend-on-idle

    # set output sink
    set-default-sink alsahw0

    # rtp receive
    load-module module-rtp-recv latency_msec=1000 sap_address=224.0.0.56
    load-module module-rtp-recv latency_msec=1000 sap_address=192.168.123.123      # for unicast

Note that `latency_msec` might need some individual adjustment. For example I use 1000ms on a wired node, but 1002ms on a wireless, since the wireless seems to introduce 2ms of lantency.

5. Make sure that PulseAudio starts

    /etc/init.d/pulseaudio enable
    /etc/init.d/pulseaudio start


