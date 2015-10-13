#!/bin/bash
bin=/etc/init.d/ceph
conf=./ceph.conf
osddev=/dev/sdc2
osdjournal=/dev/sdc1
id=0
osdpath=/var/lib/ceph/osd/ceph-$id
keyring=$osdpath/keyring

[ $# != 0 ] && id=$1

[ ! -f $conf ] && conf=/etc/ceph/ceph.conf

while [ ! `ceph osd ls |grep $id` ]
do
    ceph osd create
done

# stop osd
$bin -c $conf stop osd.$id

# mount osd device
umount $osddev 2>/dev/null
mkfs.btrfs $osddev 2>/dev/null
[ ! -f $osdpath ] && mkdir -p $osdpath
mount $osddev $osdpath
dd if=/dev/zero of=$osdjournal bs=1M count=10 2>/dev/null

# start osd
ceph auth del osd.$id
ceph-osd -i $id --mkfs --mkkey --mkjournal
ceph auth add osd.$id osd 'allow *' mon 'allow rwx' -i $keyring
$bin -c $conf start osd.$id
