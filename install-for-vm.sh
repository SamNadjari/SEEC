
#install sshd ifconfig vim
sudo apt-get -y update
sudo apt-get -y install vim net-tools openssh-server tshark

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
#to install the latest imagemagick 7.*
sudo apt-get install build-essential
sudo apt-get install libpng-dev
wget http://www.imagemagick.org/download/ImageMagick.tar.gz
tar -xvf ImageMagick.tar.gz
cd ImageMagick-7.0.*
./configure --prefix=/usr
make
sudo make install
sudo ldconfig /usr/local/lib
