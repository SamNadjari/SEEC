#!/bin/bash

#run this script with another script (
#sudo ./vq-expt.sh vnc wifi 1
#88888888
#run the script with sudo and change the IP address in the tshark command below

app=$1
tech=$2
runNo=$3

video_name=30-sec-vidoe.mp4
vm_IF=ens3
log_dir=/home/k/vq-study

#====== slow motion
output_file=$app-slow-mplayer-$tech_$runNo
tcpdump -i $vm_IF -w $log_dir/$output_file.pcap &
{ time mplayer -fps 1 $video_name ;} 2> $log_dir/mplayer-log-$output_file.txt # the { is used to make sure the output of time is as well saved into the file
killall tcpdump

#get time of playing the video, get minutes then seconds
min=`cat $log_dir/mplayer-log-$output_file.txt | grep 'real' | awk '{print $2}' | rev | cut -c 2- | rev | sed 's/m/\n/g' | head -n 1`
sec=`cat $log_dir/mplayer-log-$output_file.txt | grep 'real' | awk '{print $2}' | rev | cut -c 2- | rev | sed 's/m/\n/g' | tail -n 1`
total_time_slow=$(bc <<< "scale=2;($min*60)+$sec") #unit sec
echo "FATMA time" $total_time_slow

total_bytes_slow=`tshark -q -z "io,stat,0,ip.src==192.168.122.216" -r $log_dir/$output_file.pcap | grep '<>' | awk '{print $8}'`
echo "total bytes" $total_bytes_slow

#====== regular motion
output_file=$app-regular-mplayer-$tech_$runNo
tcpdump -i $vm_IF -w $log_dir/$output_file.pcap &
{ time mplayer -fps 24 $video_name ;} 2> $log_dir/mplayer-log-$output_file.txt
killall tcpdump

#get time of playing the video, get minutes then seconds
min=`cat $log_dir/mplayer-log-$output_file.txt | grep 'real' | awk '{print $2}' | rev | cut -c 2- | rev | sed 's/m/\n/g' | head -n 1`
sec=`cat $log_dir/mplayer-log-$output_file.txt | grep 'real' | awk '{print $2}' | rev | cut -c 2- | rev | sed 's/m/\n/g' | tail -n 1`
total_time_regular=$(bc <<< "scale=2;($min*60)+$sec") #unit sec
echo $total_time_regular

total_bytes_regular=`tshark -q -z "io,stat,0,ip.src==192.168.122.216" -r $log_dir/$output_file.pcap | grep '<>' | awk '{print $8}'`

#========== video quality

vq=$(bc <<< "scale=2; (($total_bytes_regular/$total_time_regular)/24) / (($total_bytes_slow/$total_time_slow)/1)")
echo "vq is" $vq
echo $video_name $app $runNo $tech $total_bytes_regular $total_time_regular $total_bytes_slow $total_time_slow $vq >> $log_dir/vq-results
