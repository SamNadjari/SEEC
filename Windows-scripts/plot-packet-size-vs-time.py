#this script read a pcap, process it with tshark and extract ts and size then plot

import sys, os
import matplotlib.pyplot as plt
import numpy as np

#input arguments
dst_IP="172.28.30.9"
pcap= sys.argv[1] #"capture-1-slow.pcap " #"no-display-updates.pcap"
parsed_pcap="tshark-pckts-parsed"
res_dir="/home/harlem1/SEEC/Windows-scripts/results"
plot_dir="/home/harlem1/SEEC/Windows-scripts/plots"
plot_name=pcap+"-pcoip-packets-10-mins"
#process the pcap file and extract ts and size
command = "tshark -r " + pcap +" \"ip.dst=="+ dst_IP +" and not icmp\" | grep \"UDP\" | awk '{print $2,$7}' > "+ res_dir + "/" + parsed_pcap
os.system(command)

#load the parsed pcap file data (ts, packet size, dst port)
ts,size = np.loadtxt(res_dir+"/"+parsed_pcap, delimiter=' ', usecols=(0,1),unpack=True)

ts_x = []
size_x = []

count_110 = 0
count_gt_110 = 0 #counter for packetes greater than 110 B

for t in range(len(ts)):
    if ts[t] <= 600.0:
        ts_x.append(ts[t])
        size_x.append(size[t])
        if size[t] == 110:
            count_110 = count_110 + 1
        else:
            count_gt_110 = count_gt_110 +1
    else:
        break

print("count_gt_110 ", count_gt_110)
print("count_110 ",count_110)
#plot
plt.plot(ts_x,size_x)
#plt.scatter(ts,size)
plt.xlabel('Time (s)',fontsize=14)
plt.ylabel('Packet size (Bytes)',fontsize=14)
plt.savefig(plot_dir + '/'+plot_name+'.png',format="png",bbox_inches='tight')
plt.show()
