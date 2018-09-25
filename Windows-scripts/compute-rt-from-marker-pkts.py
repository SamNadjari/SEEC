#This is a python3 code
#example: python3 compute-rt-from-marker-pkts.py 172.28.30.68 4 capture-1-slow.pcap 20 1 Gimp

import sys, os
import numpy as np

dst_IP=sys.argv[1]
no_tasks=int(sys.argv[2]) #number of tasks performed in the slow motion test
pcap=sys.argv[3]
rtt=sys.argv[4]
loss=sys.argv[5]
app=sys.argv[6]

res_dir="/home/harlem1/SEEC/Windows-scripts/results"

#process the pcap file and get the marker packets timestamps
command="tshark -r "+ pcap + " \"ip.dst==" + dst_IP + "  and udp.dstport==60000\" | grep \" → " +dst_IP + "\" | awk '{print $2}' > " + res_dir + "/filex"

os.system(command)
ts = np.loadtxt(res_dir +'/filex', delimiter=' ')

rt = [rtt,loss] #response time for each task
#each two consecutive marker packets represent one task and the difference is the task duration (reponse time)
for i in range(0,no_tasks*2,2):
  diff = ts[i+1] - ts[i]
  rt.append(diff)

#save results to file
#change to np array to save file
rt = np.array(rt)
#file_name = app+"_RT_marker_packets_rtt"+rtt+"_loss_"+loss 
file_name = app+"_RT_marker_packets"
f=open(res_dir + '/' + file_name,'ab') #open the file to append to
np.savetxt(f, rt.reshape(1, rt.shape[0]), fmt="%s") #the reshape function is used to convert the array to row-wise array to be saved as one row in the file
f.close()

#delete pcap and parsed file
command="rm "+ res_dir + "/filex"
os.system(command)
