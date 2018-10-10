
#This script fit RT in different ML models

import sys, os
import numpy as np
import matplotlib.cm as cm
import matplotlib.pyplot as plt
from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score

#=====================Initialize parameters===============
#input arguments
app="ImageView"
total_runs=10
res_dir="/home/harlem1/SEEC/Windows-scripts/results"
plot_dir='/home/harlem1/SEEC/Windows-scripts/plots/new-mean'
method=["display_updates_2"] #["autoit","display_updates","display_updates_2"] #"RT_marker_packets_2"
run_no=16
no_tasks=6

#====================Read Data===========================
#for each RT method create a model
for meth in method:
    file_name = app + "_RT_"+method[0]+"_run_"+str(run_no)
    #create variable for each method
    temp1 = "data_"+meth
    if meth != "autoit": #it doesn't have total no of bytes to read
        globals()[temp1] = np.loadtxt(res_dir +'/' + file_name, delimiter=' ') #,usecols=(i+2,),unpack=True)

#===================Pre-process data and create required matrix format================

for meth in method:
    temp1 = "data_"+meth
    temp2_x = "data_"+meth+"_x" #array name for features
    temp3_y = "data_"+meth+"_y" #array name for output (RT)

    globals()[temp2_x] = []
    globals()[temp3_y] = []
    temp_array = []
    for row_elements in globals()[temp1]:
        for task in range(no_tasks):
            globals()[temp2_x].append([row_elements[0],row_elements[1],row_elements[task+8]]) #rtt, loss, bytes
            globals()[temp3_y].append(row_elements[task+2]) #read RT
    #print("temp2_x, ",temp2_x," ", globals()[temp2_x])


#===================Model fitting======================

for meth in method:
    temp2_x = "data_"+meth+"_x" #array name for features
    temp3_y = "data_"+meth+"_y" #array name for output (RT)
   
    reg = linear_model.LinearRegression()
    reg.fit (globals()[temp2_x],globals()[temp3_y])
 
    # Make predictions using the testing set
    diabetes_y_pred = reg.predict(globals()[temp2_x])
    # The coefficients
    print('Coefficients: \n', reg.coef_)
    # The mean squared error
    print("Mean squared error: %.2f"
          % mean_squared_error(globals()[temp3_y], diabetes_y_pred))
    # Explained variance score: 1 is perfect prediction
    print('Variance score: %.2f' % r2_score(globals()[temp3_y], diabetes_y_pred))

    globals()[temp2_x] = np.asarray(globals()[temp2_x])
    # Plot outputs
    plt.scatter(globals()[temp2_x][:,2], diabetes_y_pred,  color='black')
#    plt.plot(globals()[temp2_x][:,2], diabetes_y_pred, color='blue', linewidth=3)

    plt.show()
