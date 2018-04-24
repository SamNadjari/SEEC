# This script runs at the client
#Make sure cnee is installed
#run the script with sudo 

run_no=1
sleep_time=40
rdp=client-teamviewer-with-vm-client-no-loss
traces_dir=results/traces/

file_name=run-$run_no-cnee-$rdp-$sleep_time-sec-sleep-no-filter

export DISPLAY=:0

sleep 5
#start tcpdump
echo "start tcpdump"
sudo tcpdump -B 4096 -i ens3 -w $traces_dir$file_name.pcap &

#sleep
echo sleep for $sleep_time
sleep $sleep_time

echo "open firefox"
cnee --replay --recall-window-position -f openfirefox.xns -ns --force-core-replay --speed-percent 200

echo "sleep"
sleep $sleep_time
echo "visit food blog"
cnee --replay --recall-window-position -f visitFoodBlog.xns -ns --force-core-replay --speed-percent 200

echo "sleep"
sleep $sleep_time
echo "visit image web page"
cnee --replay --recall-window-position -f visitImage.xns -ns --force-core-replay --speed-percent 200

echo "sleep"
sleep $sleep_time
echo "close firefox"
cnee --replay --recall-window-position -f closeFirefox.xns -ns --force-core-replay --speed-percent 200


echo "kill tcpdump"
sudo killall tcpdump

echo done


