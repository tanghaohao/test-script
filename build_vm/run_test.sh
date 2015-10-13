#!/bin/bash
vms=3
ip=192.168.2.2
runtime=720
conf="load fileserver   \
    set \\\$dir=/mnt    \
    run $runtime"
for id in `seq 1 $vms`
do
    vmip=$ip$id
    # waiting for vm
    while [ -z "`ssh $vmip ls /`" ]
    do
        sleep 1
    done

    cmd=
    [ ! -z "$conf" ] && cmd="echo \"$conf\" > ./opt.conf"
    cmd="$cmd && ./setup.sh 2>/dev/null"
    echo ssh $vmip $cmd
    ssh $vmip $cmd
done

for id in `seq 1 $vms`
do
    vmip=$ip$id
    ssh $vmip filebench -f opt.conf &
done

wait
