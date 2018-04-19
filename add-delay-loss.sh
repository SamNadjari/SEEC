
# This script ise used to shape the traffic and to increase the RTT of the path

IF=ens3
rate=1000mbit
limit=10mb #should equal to 2 BDP to ensure no packet is dropped by tc
RTT=0ms #30ms
loss=0.1% #0.01%

sudo tc qdisc del dev $IF root

sudo tc qdisc add dev $IF root handle 1: htb default 11
sudo tc class add dev $IF parent 1: classid 1:1 htb rate $rate

sudo tc class add dev $IF parent 1:1 classid 1:10 htb rate $rate 
sudo tc class add dev $IF parent 1:1 classid 1:11 htb rate $rate

sudo tc qdisc add dev $IF parent 1:10 handle 10: netem delay $RTT loss $loss

U32="sudo tc filter add dev $IF protocol ip parent 1:0 prio 1 u32"
$U32 match ip dst 192.168.122.216/32 flowid 1:10
#$U32 match ip sport 50202 0xffff flowid 1:10
