
#install sshd ifconfig vim
sudo apt-get -y update
sudo apt-get -y install vim net-tools opens-server tshark

#install x2go
sudo apt-get -y install software-properties-common python-software-properties
sudo add-apt-repository ppa:x2go/stable
sudo apt-get update
sudo apt-get -y install x2goserver x2goserver-xsession

#install vnc
#sudo apt-get -y install tightvncserver

#install mplayer
sudo apt-get install mplayer mplayer-gui mplayer-skin

#install imagemagick
sudo apt-get install imagemagick imagemagick-doc
