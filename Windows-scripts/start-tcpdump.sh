IF=$1
speed=$2
tcpdump -i $IF -s 100 -w capture-1-$speed.pcap &
