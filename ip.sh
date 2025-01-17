sudo nmcli con mod wlp2s0 ipv4.method manual ipv4.addresses 192.168.2.222/24 ipv4.gateway 192.168.2.1 ipv4.dns "8.8.8.8 114.114.114.114"
sudo nmcli con up wlp2s0