
pcap_file=$1
client_IP=$2
rtt=$3
loss=$4
dir=$5
runNo=$6

file_name=thru-data-delay-$rtt-loss-$loss-runNo-$runNo.txt
#dir=/home/harlem1/SEEC/Windows-scripts
res_dir=/home/harlem1/SEEC/Windows-scripts/results

tshark -q -nr $dir/$pcap_file -z io,stat,0.001,ip.dst==$client_IP,"ip.dst==$client_IP && udp.port==60000" | grep "<>" | awk '{print $8 " " $12}' > $res_dir/$file_name

#plot the network trace
python3 $dir/plot-thru.py $res_dir $file_name

rm $res_dir/$file_name
