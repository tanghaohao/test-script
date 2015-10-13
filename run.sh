#!/bin/bash
pkill qemu
ceph=./build_cluster
qemu=./build_vm

echo "Setup Ceph Cluster..."
$ceph/build_monitor.sh 1>/dev/null
$ceph/setup_osd.sh 1>/dev/null 2>/dev/null

echo "Start virtual machine..."
$qemu/start_vm.sh 1>/dev/null
echo sleep 4s
count=0
while [ $count != 4 ]
do
    sleep 1
    let count=count+1
    echo $count 
done

echo "run test in virtual machine..."
$qemu/run_test.sh
