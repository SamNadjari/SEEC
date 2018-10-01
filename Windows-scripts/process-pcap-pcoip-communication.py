
import sys, os
import numpy as np


#======================= Main Program ===================

#input arguments
dst_IP="172.28.30.9"
pcap= sys.argv[1] #"capture-1-slow.pcap " #"no-display-updates.pcap"
parsed_pcap="tshark-pckts-parsed"
res_dir="/home/harlem1/SEEC/Windows-scripts/results"
#log_dir="/home/harlem1/SEEC/Windows-scripts"

#process the pcap file
command = "tshark -r " + pcap +" \"ip.dst=="+ dst_IP +" and not icmp\" | grep \"UDP 110\" | awk '{print $2}' > "+ res_dir + "/" + parsed_pcap
os.system(command)

#load the parsed pcap file data (ts, packet size)
ts = np.loadtxt(res_dir+"/"+parsed_pcap, delimiter=' ')

#find the time difference between communication packets
ts_diff = np.ediff1d(ts)
print("mean = ", np.mean(ts_diff))
print("sd = ", np.std(ts_diff))
print("median = ", np.median(ts_diff))
print("variance = ", np.var(ts_diff))
print("max = ", np.amax(ts_diff))
print("min = ", np.amin(ts_diff))
print("75th percentile = ", np.percentile(ts_diff,75))

#np.savetxt("xxx", ts_diff) #, fmt="%s")

#measure the time difference between the display updates packets (packates > 110)
#process the pcap file and get the marker packets timestamps
command = "tshark -r " + pcap +" \"ip.dst=="+ dst_IP +" and not icmp\" | grep UDP | awk '{print $2,$7,$10}' > "+ res_dir + "/" + parsed_pcap
os.system(command)

#load the parsed pcap file data (ts, packet size, dst port)
ts,size,port = np.loadtxt(res_dir+"/"+parsed_pcap, delimiter=' ', usecols=(0,1,2),unpack=True)

all_ts_diff = []

for j in range(0,len(size)):
    if size[j] <= 110:
        continue
    else:
        all_ts_diff.append(ts[j])


#the time difference between all packets >110B
all_ts_diff = np.asarray(all_ts_diff)
all_ts_diff = np.ediff1d(all_ts_diff)
xx="display-all-time-diff-pckts-greater-110B.txt"
np.savetxt(xx, all_ts_diff,fmt="%2.6f")

print("mean = ", np.mean(all_ts_diff))
print("sd = ", np.std(all_ts_diff))
print("median = ", np.median(all_ts_diff))
print("variance = ", np.var(all_ts_diff))
print("max = ", np.amax(all_ts_diff))
print("min = ", np.amin(all_ts_diff))
print("75th percentile = ", np.percentile(all_ts_diff,75))


