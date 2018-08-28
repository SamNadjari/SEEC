#!/bin/bash

#run this script with another script (
#sudo ./vq-expt.sh vnc wifi 1
#88888888
#run the script with sudo and change the IP address in the tshark command below

#runNo=$1




total_time_slow=$1
total_time_regular=$2

log_dir=/home/fatma
pcap_file=capture-1

total_bytes_slow=`tshark -q -z "io,stat,0,ip.src==10.101.3.3" -r $log_dir/$pcap_file-slow.pcap | grep '<>' | awk '{print $8}'`
echo "total bytes" $total_bytes_slow


total_bytes_regular=`tshark -q -z "io,stat,0,ip.src==10.101.3.3" -r $log_dir/$pcap_file-regular.pcap | grep '<>' | awk '{print $8}'`

#========== video quality

vq=$(bc <<< "scale=2; (($total_bytes_regular/$total_time_regular)/24) / (($total_bytes_slow/$total_time_slow)/1)")
echo "vq is" $vq
#echo $video_name $app $runNo $tech $total_bytes_regular $total_time_regular $total_bytes_slow $total_time_slow $vq >> $log_dir/vq-results
