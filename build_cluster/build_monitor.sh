bin=/etc/init.d/ceph
conf=./ceph.conf
monkeyring=/tmp/ceph.mon.keyring
adminkeyring=/etc/ceph/ceph.client.admin.keyring
monmap=/tmp/monmap
monpath=/var/lib/ceph/mon
cephrun=/var/run/ceph
hostname=ceph-2
ip=192.168.1.112
numosd=1

if [ ! -f $conf ]
then
    conf=/etc/ceph/ceph.conf
fi
$bin -c $conf -a stop

[ -f $monkeyring ] && rm $monkeyring
[ -f $adminkeyring ] && rm $adminkeyring
[ -f $monmap ] && rm $monmap
[ -d $monpath ] && rm $monpath -rf
[ -d $cephrun ] && rm $cephrun -rf
mkdir $monpath
mkdir $cephrun
ceph-authtool --create-keyring $monkeyring --gen-key -n mon. --cap mon 'allow *'
ceph-authtool --create-keyring $adminkeyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'
ceph-authtool $monkeyring --import-keyring $adminkeyring
monmaptool --create --add $hostname $ip --fsid 0e24706b-a1e8-44be-ac1d-1ffe698451fc $monmap
ceph-mon --mkfs -i $hostname --monmap $monmap --keyring $monkeyring
$bin -c $conf start mon.$hostname
while [ $numosd != 0 ]
do
    ceph osd create
    let numosd=numosd-1
done
ceph osd pool set rbd size 1 2>/dev/null
