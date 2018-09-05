#!/bin/bash

set -e

if [ -z ${INTERFACE} ]; then
	INTERFACE=`find /sys/class/net -follow -maxdepth 2 -name phy80211 2> /dev/null | cut -d / -f 5`
fi

echo "
interface=${INTERFACE}
ssid=${SSID}
hw_mode=g
wpa=2
wpa_passphrase=${PASSWORD}
wpa_key_mgmt=WPA-PSK
channel=${CHANNEL}
macaddr_acl=0
auth_algs=3
driver=nl80211
ieee80211n=1
wmm_enabled=1
beacon_int=100
rsn_pairwise=CCMP
wpa_pairwise=CCMP
ignore_broadcast_ssid=0
" > /etc/hostapd.conf

echo "
interface ${INTERFACE}
start 10.254.1.100
end 10.254.1.150
max_leases=50
offer_time 60
lease_file /var/lib/misc/udhcpd.leases
" > /etc/udhcpd.conf

rfkill block wifi
rfkill unblock wifi
hostapd /etc/hostapd.conf -B
ifconfig ${INTERFACE} 10.254.1.1
udhcpd /etc/udhcpd.conf
sleep infinity
