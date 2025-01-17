sudo nmcli con mod wlx801f028e0eeb ipv4.method manual ipv4.addresses 192.168.2.223/24 ipv4.gateway 192.168.2.1 ipv4.dns "8.8.8.8 114.114.114.114"
sudo nmcli con up wlx801f028e0eeb
