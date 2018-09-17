
pcap_file=$1
client_IP=$2
tshark -q -nr $pcap_file -z io,stat,0.001,ip.dst==$client_IP,"ip.dst==$client_IP && udp.port==60000" | grep "<>" | awk '{print $8 " " $12}'
