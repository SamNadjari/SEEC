# First use this VM as the server, and from another machine (VM, laptop) connect to this VM

import webbrowser
import time, os


run_no = 1
sleep_time = 40
rdp = "with-capture-teamviewer-with-vm-client-no-loss"
client_IP = "192.168.122.216"
client_user = "k"
traces_dir = "SEEC/results/traces/"

#for some reasons when I run this command here, it cannot set the variable, so I did it in another shell script which calls this script
#os.system("export DISPLAY=:0")

file_name = "run-"+str(run_no)+"-python-"+rdp+"-"+str(sleep_time)+"sec-sleep-no-filter"

print("start tcpdump")
tcpdump_command = "sudo tcpdump -B 4096 -i ens3 -w "+traces_dir+file_name+".pcap &"
print(tcpdump_command)
os.system(tcpdump_command)

time.sleep(sleep_time)

#capture display at the client
print("Capture client display")
capture_display_commnad = "ssh "+client_user+"@"+client_IP+" \"sh SEEC/export-display-client.sh "+file_name+"-1\""
os.system(capture_display_commnad)

print("Launch firefox")
#measure firefox launch time
#os.system("DISPLAY=:0 firefox &") #setup DISPLAY to the teamviewer display to launch firefox there
os.system("firefox &")

print("sleep for 10 sec")
time.sleep(sleep_time)

print("open food blog")
#os.system("DISPLAY=:0 firefox -new-tab -url https://pinchofyum.com")
webbrowser.get('firefox').open('https://pinchofyum.com')

print("sleep for 10 sec")
time.sleep(sleep_time)

#capture display at the client
print("Capture client display")
capture_display_commnad = "ssh "+client_user+"@"+client_IP+" \"sh SEEC/export-display-client.sh "+file_name+"-2\""
os.system(capture_display_commnad)

print("open pure image")
#os.system("DISPLAY=:0 firefox -new-tab -url https://upload.wikimedia.org/wikipedia/commons/1/16/Appearance_of_sky_for_weather_forecast%2C_Dhaka%2C_Bangladesh.JPG")
webbrowser.get('firefox').open('https://upload.wikimedia.org/wikipedia/commons/1/16/Appearance_of_sky_for_weather_forecast%2C_Dhaka%2C_Bangladesh.JPG')
time.sleep(sleep_time)

#capture display at the client
print("Capture client display")
capture_display_commnad = "ssh "+client_user+"@"+client_IP+" \"sh SEEC/export-display-client.sh "+file_name+"-3\""
os.system(capture_display_commnad)

print("Kill tcpdump")
os.system("sudo killall tcpdump")

print("clos firefox")
os.system("sudo killall firefox")

print("done")


'''
from selenium import webdriver
from time import sleep

driver = webdriver.Firefox()
driver.get("http://google.co.uk")
sleep(10)
driver.close()
'''
