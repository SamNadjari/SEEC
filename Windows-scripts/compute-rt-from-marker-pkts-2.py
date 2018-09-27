#This is a python3 code
#input: dst_IP pcap rtt loss app

import sys, os
import numpy as np


#======================= Main Program ===================

#input arguments
dst_IP=sys.argv[1]
pcap=sys.argv[2]
rtt=sys.argv[3]
loss=sys.argv[4]
app=sys.argv[5]

parsed_pcap="tshark-pckts-parsed"
res_dir="/home/harlem1/SEEC/Windows-scripts/results"
#log_dir="/home/harlem1/SEEC/Windows-scripts"

#process the pcap file and get the marker packets timestamps
command = "tshark -r " + pcap +" \"ip.dst=="+ dst_IP +" and not icmp\" | grep UDP | awk '{print $2,$7,$10}' > "+ res_dir + "/" + parsed_pcap
os.system(command)

#load the parsed pcap file data (ts, packet size, dst port)
ts,size,port = np.loadtxt(res_dir+"/"+parsed_pcap, delimiter=' ', usecols=(0,1,2),unpack=True)

#find indces of marker packtes, every other index represents the start marker packets
marker_index = np.where(port==60000)

#convert it to a list structure to easily access elemts in a loop
#marker_index.tolist() #tolist not working it might be abuild error so we'll convert it manully
mk_index = []
for i in range(len(marker_index[0])):
    mk_index.append(marker_index[0][i])

#find RT for each task
rt = [rtt, loss] #array for RTs, initialize it with rtt and loss to write the results to a file
sz = [] #size of the display updates for each task, unit bytes

for i in range(0,len(mk_index),2): #step by 2 because the 2nd marker would be the packetsindicate the end of task, which we don't need
    index = mk_index[i]

    start_ts = ts[index]
    sz_temp = 0 #to compute the total size of display updates
    for j in range(index+1,len(size)):
        if port[j] != 60000:
            sz_temp+= size[j]
            continue
        else: #we've reached the second marker packets indicating the end of task
            end_ts = ts[j]
            resp_time = end_ts - start_ts 
            print("rt =",resp_time)
            rt.append(resp_time)
            sz.append(sz_temp)
            break

#save results to file
#change to np array to save file
rt = rt + sz #add the byte size of each task to rt array to write both rt and size to one output file
rt = np.array(rt)
#file_name = app+"_RT_marker_packets_rtt"+rtt+"_loss_"+loss 
file_name = app+"_RT_marker_packets_2"
f=open(res_dir + '/' + file_name,'ab') #open the file to append to
np.savetxt(f, rt.reshape(1, rt.shape[0]), fmt="%s") #the reshape function is used to convert the array to row-wise array to be saved as one row in the file
f.close()

#delete pcap and parsed file
command = "rm "+ res_dir + "/" + parsed_pcap
os.system(command) 
