#/bin/bash
ifconfig eth1 down
brctl addbr br0
brctl addif br0 eth1
ifconfig eth1 0.0.0.0 promisc up
ifconfig br0 192.168.2.1
for id in `seq 1 8`;do
	tunctl -t tap$id -u root
	brctl addif br0 tap$id
done
brctl show br0
