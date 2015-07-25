#steps for installing R latest version on ubuntu 14.04
sudo apt-get update
sudo apt-get install make -y
sudo apt-get install cmake -y
sudo apt-get install gcc -y
sudo apt-get install unzip -y
sudo apt-get install g++ -y

#following these instructions https://cran.r-project.org/bin/linux/ubuntu/
#could also do nano /etc/apt/sources.list
line_add="deb http://lib.stat.cmu.edu/R/CRAN/bin/linux/ubuntu trusty/"
echo $line_add | sudo tee -a /etc/apt/sources.list

#force-yes is not recommended but this mirror is not auto-authenticated by ubuntu and we want it to work on start-up 
sudo apt-get update 
sudo apt-get install r-base -y --force-yes
sudo apt-get install r-base-dev -y --force-yes