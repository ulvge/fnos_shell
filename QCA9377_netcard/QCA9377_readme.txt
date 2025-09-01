叶庆庆的两台笔记本电脑
型号是
联想120s-141ap
网卡qca9377
cpu N3350 

思路：
当wifi连不上时，根据日志
    dmesg | grep ath10k
发现是驱动问题，需要安装驱动。
仔细查看输出，很可能会看到类似 failed to fetch firmware file 'ath10k/pre-cal-pci-0000:02:00.0.bin' 或 failed to fetch board data 的错误信息。这明确指出了需要安装固件


一、安装无线网卡QCA9377，需要安装驱动，
驱动下载地址为：
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/ath10k/QCA9377/hw1.0/
下载目录内的所有bin文件。
    board-2.bin
    board.bin
    firmware-5.bin
    firmware-6.bin
    firmware-sdio-5.bin

二、挂载U盘
    root@ye:/# lsblk
    NAME                                              MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
    sda                                                 8:0    0 119.2G  0 disk
    ├─sda1                                              8:1    0    94M  0 part  /boot/efi
    ├─sda2                                              8:2    0  69.9G  0 part  /
    └─sda3                                              8:3    0  49.2G  0 part
    └─md0                                             9:0    0  49.2G  0 raid1
        └─trim_405e50ad_d3f0_4724_923d_89410c73b427-0 253:0    0  49.2G  0 lvm   /vol1
    sdb                                                 8:16   1  28.6G  0 disk
    ├─sdb1                                              8:17   1  28.6G  0 part  /mnt/usb
    │                                                                            /vol00/Ultra_USB_3.0
    └─sdb2                                              8:18   1    32M  0 part  /vol00/Ultra_USB_3.0_1

    创建挂载点
        sudo mkdir /mnt/usb
    挂载设备：将U盘分区挂载到你刚创建的目录上。
        sudo mount /dev/sdb1 /mnt/usb


二、复制文件到 /lib/firmware/ath10k/QCA9377/hw1.0/目录下
    创建目标目录（如果不存在）
        sudo mkdir -p /lib/firmware/ath10k/QCA9377/hw1.0/
        cd /lib/firmware/ath10k/QCA9377/hw1.0/

        cp /mnt/usb/board-2.bin         board-2.bin
        cp /mnt/usb/board.bin           board.bin
        cp /mnt/usb/firmware-5.bin      firmware-5.bin
        cp /mnt/usb/firmware-6.bin      firmware-6.bin
        cp /mnt/usb/firmware-sdio-5.bin firmware-sdio-5.bin
    添加权限
        sudo chmod 777 *
三、重新加载驱动
    sudo rmmod ath10k_pci
    sudo rmmod ath10k_core
    sudo modprobe ath10k_pci

四、连接wifi
    确认开启wifi
    sudo nmcli radio wifi on  # 确保Wi-Fi射频是开启状态
    sudo nmcli dev wifi list  # 扫描并列出所有可用的Wi-Fi网络

    打开扫描并连接的UI
    nmtui
    选择 Activate a connection
