
import matplotlib
matplotlib.use('Agg') #so that we don't get no $Display variable error when running the script over ssh connection

import numpy as np
import matplotlib.pyplot as plt
import sys

res_dir=sys.argv[1]
file_name=sys.argv[2]
app=sys.argv[3]
plot_dir='/home/harlem1/SEEC/Windows-scripts/plots/'
#read data
data1, data2 = np.loadtxt(res_dir +'/'+ file_name, delimiter=' ',usecols=(0,1),unpack=True)


fig, ax1 = plt.subplots(1)
ax1.set_xlabel('Time (ms)',fontsize=14)
ax1.set_ylabel('Rate: Mbits per ms')
ax1.plot((data1/0.001)/1e6,linewidth=2.0)
#ax1.annotate('Reject rate', xy=(8, 36), xytext=(8, 35),arrowprops=dict(facecolor='black', shrink=0.05))
#ax1.tick_params(axis='both', which='major', labelsize=14)
#ax1.set_ylim(30,50)
#ax1.legend(loc='upper left',ncol=3,bbox_to_anchor=(0.1,1.15))

ax2 = ax1.twinx()  # instantiate a second axes that shares the same x-axis
ax2.set_ylabel('Marker packets')  # we already handled the x-label with ax1
ax2.plot(data2,"r--",linewidth=2.0)
#ax2.axvline(x=(7.749935+20.561228)*1e3,color="y",linewidth=2.0)
#ax2.axvline(x=(0.827991+43.968891)*1e3,color="y",linewidth=2.0)
#ax2.axvline(x=(2.057551+85.389765)*1e3,color="y",linewidth=2.0)
#ax2.annotate('Utilization', xy=(4, 46), xytext=(4, 42),arrowprops=dict(facecolor='black', shrink=0.05))
#ax2.tick_params(axis='both', which='major', labelsize=14)
#ax2.set_ylim(50,75)

plt.savefig(plot_dir + 'RT-'+app+'-'+file_name+'.png',format="png",bbox_inches='tight')
plt.show()
