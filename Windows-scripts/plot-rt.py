#Plot RT and Bytes

import matplotlib
matplotlib.use('Agg') #so that we don't get no $Display variable error when running the script over ssh connection

import numpy as np
import matplotlib.pyplot as plt
import sys, math

res_dir='/home/harlem1/SEEC/Windows-scripts/results'
app="gimp"
plot_dir='/home/harlem1/SEEC/Windows-scripts/plots'
run_no=4
#==============read data====================
#rt-a: RT measured within autoit script
#rt-m: RT measured by marker packets
#rt-d: RT measured by display updates in the packet trace
file_name = app + "-RT-autoit-run-no-"+str(run_no) +".txt"
rtt, loss, rt_a_1, rt_a_2, rt_a_3 = np.loadtxt(res_dir +'/' + file_name, delimiter=' ',usecols=(0,1,2,3,4),unpack=True)

file_name = app + "_RT_marker_packets_2_run_" +str(run_no)
rt_m_1, rt_m_2, rt_m_3, byt_m_1, byt_m_2, byt_m_3 = np.loadtxt(res_dir +'/' + file_name, delimiter=' ',usecols=(2,3,4,5,6,6),unpack=True)

file_name = app + "_RT_display_updates_run_" +str(run_no)
rt_d_1, rt_d_2, rt_d_3, byt_d_1, byt_d_2, byt_d_3 = np.loadtxt(res_dir +'/' + file_name, delimiter=' ',usecols=(2,3,4,5,6,6),unpack=True)

#===================Parse data by Loss rate and tasks=========================
loss_0_ind = np.where(loss==0)
loss_3_ind = np.where(loss==3)

#convert it to a list structure to easily access elemts in a loop
loss_0_index = []
loss_3_index = []
for i in range(len(loss_0_ind[0])):
    loss_0_index.append(loss_0_ind[0][i])

for i in range(len(loss_3_ind[0])):
    loss_3_index.append(loss_3_ind[0][i])

rttx = []
rt_a_1_loss_0 = []
rt_a_2_loss_0 = []
rt_a_3_loss_0 = []
rt_m_1_loss_0 = [] 
rt_m_2_loss_0 = []
rt_m_3_loss_0 = []
byt_m_1_loss_0 = [] 
byt_m_2_loss_0 = []
byt_m_3_loss_0 = []
rt_d_1_loss_0 = []
rt_d_2_loss_0 = []
rt_d_3_loss_0 = []
byt_d_1_loss_0 = []
byt_d_2_loss_0 = []
byt_d_3_loss_0 = []
for i in range(len(loss_0_index)):
    index = loss_0_index[i]
    rttx.append(rtt[index])

    rt_a_1_loss_0.append(rt_a_1[index])
    rt_a_2_loss_0.append(rt_a_2[index])
    rt_a_3_loss_0.append(rt_a_3[index])

    rt_m_1_loss_0.append(rt_m_1[index])
    rt_m_2_loss_0.append(rt_m_2[index])
    rt_m_3_loss_0.append(rt_m_3[index])
    byt_m_1_loss_0.append(byt_m_1[index])
    byt_m_2_loss_0.append(byt_m_2[index])
    byt_m_3_loss_0.append(byt_m_3[index])
 
    rt_d_1_loss_0.append(rt_d_1[index])
    rt_d_2_loss_0.append(rt_d_2[index])
    rt_d_3_loss_0.append(rt_d_3[index])
    byt_d_1_loss_0.append(byt_d_1[index])
    byt_d_2_loss_0.append(byt_d_2[index])
    byt_d_3_loss_0.append(byt_d_3[index])

rt_a_1_loss_3 = [] 
rt_a_2_loss_3 = []
rt_a_3_loss_3 = []
rt_m_1_loss_3 = []
rt_m_2_loss_3 = []
rt_m_3_loss_3 = []
byt_m_1_loss_3 = []
byt_m_2_loss_3 = []
byt_m_3_loss_3 = []
rt_d_1_loss_3 = []
rt_d_2_loss_3 = []
rt_d_3_loss_3 = []
byt_d_1_loss_3 = []
byt_d_2_loss_3 = []
byt_d_3_loss_3 = []
for i in range(len(loss_3_index)):
    index = loss_3_index[i]

    rt_a_1_loss_3.append(rt_a_1[index])
    rt_a_2_loss_3.append(rt_a_2[index])
    rt_a_3_loss_3.append(rt_a_3[index])

    rt_m_1_loss_3.append(rt_m_1[index])
    rt_m_2_loss_3.append(rt_m_2[index])
    rt_m_3_loss_3.append(rt_m_3[index])
    byt_m_1_loss_3.append(byt_m_1[index])
    byt_m_2_loss_3.append(byt_m_2[index])
    byt_m_3_loss_3.append(byt_m_3[index])

    rt_d_1_loss_3.append(rt_d_1[index])
    rt_d_2_loss_3.append(rt_d_2[index])
    rt_d_3_loss_3.append(rt_d_3[index])
    byt_d_1_loss_3.append(byt_d_1[index])
    byt_d_2_loss_3.append(byt_d_2[index])
    byt_d_3_loss_3.append(byt_d_3[index])

#=========================Plot=============================
np.asarray(rttx)
rtt =np.log(rttx)
print("rtt",rtt)

#task 1 (load application
fig, ax1 = plt.subplots(1)
ax1.set_xlabel('log RTT (ms)',fontsize=14)
ax1.set_ylabel(app+' load time (sec)')
ax1.plot(rtt,rt_a_1_loss_0,'bo-',linewidth=2.0,markersize=10,label = 'Autoit, loss = 0%')
ax1.plot(rtt,rt_a_1_loss_3,'go-',linewidth=2.0,markersize=10,label = 'Autoit, loss = 3%')
ax1.plot(rtt,rt_m_1_loss_0,'bx-',linewidth=2.0,markersize=10,label = 'Marker, loss = 0%')
ax1.plot(rtt,rt_m_1_loss_3,'gx-',linewidth=2.0,markersize=10,label = 'Marker, loss = 3%')
ax1.plot(rtt,rt_d_1_loss_0,'b*-',linewidth=2.0,markersize=10,label = 'Display, loss = 0%')
ax1.plot(rtt,rt_d_1_loss_3,'g*-',linewidth=2.0,markersize=10,label = 'Display, loss = 3%')
ax1.legend(loc='upper left',ncol=3,bbox_to_anchor=(0,1.18))

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
ax2.set_ylabel('Display Update Size (Bytes)')  # we already handled the x-label with ax1
ax2.plot(rtt,byt_m_1_loss_0,'bx--',linewidth=2.0,markersize=10)
ax2.plot(rtt,byt_m_1_loss_3,'gx--',linewidth=2.0,markersize=10)
ax2.plot(rtt,byt_d_1_loss_0,'b*--',linewidth=2.0,markersize=10)
ax2.plot(rtt,byt_d_1_loss_3,'g*--',linewidth=2.0,markersize=10)

plt.savefig(plot_dir + '/RT-'+app+'-task1-run-'+str(run_no)+'.png',format="png",bbox_inches='tight')

#task 1 (load application
fig, ax1 = plt.subplots(1)
ax1.set_xlabel('log RTT (ms)',fontsize=14)
ax1.set_ylabel(app+' load time (sec)')
ax1.plot(rtt,rt_a_2_loss_0,'bo-',linewidth=2.0,markersize=10,label = 'Autoit, loss = 0%')
ax1.plot(rtt,rt_a_2_loss_3,'go-',linewidth=2.0,markersize=10,label = 'Autoit, loss = 3%')
ax1.plot(rtt,rt_m_2_loss_0,'bx-',linewidth=2.0,markersize=10,label = 'Marker, loss = 0%')
ax1.plot(rtt,rt_m_2_loss_3,'gx-',linewidth=2.0,markersize=10,label = 'Marker, loss = 3%')
ax1.plot(rtt,rt_d_2_loss_0,'b*-',linewidth=2.0,markersize=10,label = 'Display, loss = 0%')
ax1.plot(rtt,rt_d_2_loss_3,'g*-',linewidth=2.0,markersize=10,label = 'Display, loss = 3%')
ax1.legend(loc='upper left',ncol=3,bbox_to_anchor=(0,1.18))

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
ax2.set_ylabel('Display Update Size (Bytes)')  # we already handled the x-label with ax1
ax2.plot(rtt,byt_m_2_loss_0,'bx--',linewidth=2.0,markersize=10)
ax2.plot(rtt,byt_m_2_loss_3,'gx--',linewidth=2.0,markersize=10)
ax2.plot(rtt,byt_d_2_loss_0,'b*--',linewidth=2.0,markersize=10)
ax2.plot(rtt,byt_d_2_loss_3,'g*--',linewidth=2.0,markersize=10)


plt.savefig(plot_dir + '/RT-'+app+'-task2-run-'+str(run_no)+'.png',format="png",bbox_inches='tight')
plt.show()
