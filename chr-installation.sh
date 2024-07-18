#!/bin/bash
echo "This script will MikroticOS install on your server in a few seconds!"
echo "This process will WIPE your disk if you are not sure Ctrl+C NOW!!"
sleep 5
wget https://download.mikrotik.com/routeros/7.13.3/chr-7.13.3.img.zip -O chr.img.zip  && \
gunzip -c chr.img.zip > chr.img  && \
mount -o loop,offset=512 chr.img /mnt && \
cp production.backup /mnt/rw/production.backup \
ADDRESS=`ip addr show eth0 | grep global | cut -d' ' -f 6 | head -n 1` && \
GATEWAY=`ip route list | grep default | cut -d' ' -f 3` && \
echo "/import production-z1.backup
/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip service disable telnet
/user set 0 name=root password=$pass
 " > /mnt/rw/autorun.scr && \
umount /mnt && \
echo u > /proc/sysrq-trigger && \
dd if=chr.img bs=1024 of=/dev/vda && \
echo "sync disk" && \
echo s > /proc/sysrq-trigger && \
echo "Sleep 5 seconds" && \
sleep 5 && \
echo "Ok, we're rebooting.." && \
echo b > /proc/sysrq-trigger

