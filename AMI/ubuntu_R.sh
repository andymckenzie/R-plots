#steps for installing R latest version on ubuntu 14.04
sudo apt-get update
sudo apt-get install make -y
sudo apt-get install cmake -y
sudo apt-get install gcc -y
sudo apt-get install unzip -y
sudo apt-get install g++ -y

#following these instructions https://cran.r-project.org/bin/linux/ubuntu/
#could also do nano /etc/apt/sources.list
"deb http://lib.stat.cmu.edu/R/CRAN//bin/linux/ubuntu trusty/" >> /etc/apt/sources.list

sudo apt-get update
sudo apt-get install r-base
sudo apt-get install r-base-dev