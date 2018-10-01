
import matplotlib
#matplotlib.use('Agg') #so that we don't get no $Display variable error when running the script over ssh connection

import numpy as np
import matplotlib.pyplot as plt
import sys

file_name="marker-all-time-diff-pckts-greater-110B.txt"

data = np.loadtxt(file_name, delimiter=' ')

x = np.arange(0,0.3,500e-6,dtype='f')
print(x)
hist_data = plt.hist(data,x) #, normed=1, facecolor='green', alpha=0.75)
print(hist_data)
axes = plt.gca()
axes.set_ylim([0,20])
plt.show()
