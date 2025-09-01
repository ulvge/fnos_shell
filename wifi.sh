sudo nmcli connection show --active
#sudo nmcli connection down "FAST_FFF43A 2"

#sudo nmcli connection modify FAST_FFF43A ipv4.method manual
#sudo nmcli connection modify FAST_FFF43A ipv4.addresses 192.168.2.222/24
#sudo nmcli device wifi connect FAST_FFF43A password 1234567890 ifname wlp2s0



#!/bin/bash

# 1. 使用您的命令连接Wi-Fi（这会设置密码并连接，但使用DHCP）
sudo nmcli device wifi connect "FAST_FFF43A" password 1234567890 ifname wlp2s0

# 等待连接建立
sleep 2

# 2. 然后修改为静态IP配置
sudo nmcli connection modify "FAST_FFF43A 2" ipv4.method manual
sudo nmcli connection modify "FAST_FFF43A 2" ipv4.addresses 192.168.2.222/24
sudo nmcli connection modify "FAST_FFF43A 2" ipv4.gateway 192.168.2.1

# 3. 重启连接以应用静态IP（这是关键！）
sudo nmcli connection down "FAST_FFF43A 2"
sudo nmcli connection up "FAST_FFF43A 2"