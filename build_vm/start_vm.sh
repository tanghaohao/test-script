#!/bin/bash
pkill qemu
if [ $# == 0 ]
then
    num=3
else
    num=$1
fi

pool=test
numpg=128
disksize=102400 #MB
vmmem=2047
if [ -z "`ceph osd lspools |grep $pool`" ]
then
    ceph osd pool create $pool $numpg
    ceph osd pool set $pool size 1 2>/dev/null
fi

echo "start $num virtual machine !"

for id in `seq 1 $num`; do
    image="/images/ubuntu_$id.img"
    if [ ! -f "$image" ]; then
        qemu-img create -f qcow2 -o backing_file=/images/ubuntu-desktop.img $image
    fi

    disk=disk_$id
    info=`rbd list -l -p $pool|grep $disk`
    if [ -z "$info" ]
    then
        rbd create -p $pool -s $disksize $disk
    fi
    ifconfig tap$id up
    cmd="qemu-system-i386 -hda /images/ubuntu_$id.img \
        -drive file=rbd:$pool/$disk:conf=/etc/ceph/ceph.conf,if=virtio \
        -net nic,macaddr=66:66:66:66:66:$id -net tap,ifname=tap$id,script=no \
        -vnc :$id -daemonize -m $vmmem -smp 2"
    echo $cmd
    `$cmd 2>/dev/null`
done
