
#steps for installing R latest version on ubuntu 14.04

sudo apt-get update
sudo apt-get install openjdk-7-jdk -y
sudo apt-get install make -y
sudo apt-get install cmake -y
sudo apt-get install gcc -y
sudo apt-get install unzip -y
sudo apt-get install g++ -y

#for installing R, using these instructions 
#http://askubuntu.com/questions/218708/installing-latest-version-of-r-base
#this doesn't work on a server bc gedit is only for a GUI 

#but this is not working ... 

#so follow these instructions https://cran.r-project.org/bin/linux/ubuntu/
#do sudo nano /etc/apt/sources.list
#then add the below to the end 
#deb http://lib.stat.cmu.edu/R/CRAN//bin/linux/ubuntu trusty/
#exit and save 

sudo apt-get update
sudo apt-get install r-base
sudo apt-get install r-base-dev