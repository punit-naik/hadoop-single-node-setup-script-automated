#!/bin/bash
read -p "NOTE!!!: Make sure that you have downloaded and extracted hadoop tarball on your desktop. The folder name should be 'hadoop'.
A user called hduser of the group hadoop will be created automatically.
Use the password 'gec' at all password prompts. You can later change the password of the user.
Press [Enter] key to start the installation.

Also, if your system has the architecture of 64-bit, copy and replace all 'i386' occurences in this file with 'amd64'."

sudo apt-get install openssh-server

sudo apt-get install openjdk-7-jdk

sudo chmod +x -R $HOME/Desktop/hadoop

sudo addgroup hadoop

username="hduser"
password="gec"

pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)

sudo useradd -g hadoop -m -p $pass $username -s /bin/bash

var=$(sudo cat /etc/sudoers | grep -n "ALL=(ALL:ALL) ALL" | grep -n "root" | cut -d':' -f2)"s"

sudo sh -c 'sed -i -e "'$var'/root\tALL=(ALL:ALL) ALL/root\tALL=(ALL:ALL) ALL\nhduser\tALL=(ALL:ALL) ALL/" /etc/sudoers'

sudo mv $HOME/Desktop/hadoop /home/hduser
sudo chown --from=$USER hduser:hadoop /home/hduser/hadoop -R

sudo su - hduser -l -c "echo | ssh-keygen -t rsa -P """
sudo su - hduser -l -c "cat /home/hduser/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys"

sudo sh -c 'echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386
export HADOOP_PREFIX=/home/hduser/hadoop
export PATH=/usr/lib/jvm/java-7-openjdk-i386/bin:/home/hduser/hadoop/bin:\$PATH
export CLASSPATH=$CLASSPATH:/usr/share/java/mysql.jar" >> /home/hduser/.bashrc'

sudo sh -c 'echo "# disable ipv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf'

sudo -u hduser echo gec | sudo -S sh -c 'ssh-keyscan localhost >> /home/hduser/.ssh/known_hosts'
sudo -u hduser ssh localhost 'sleep 1 &'
sudo -u hduser echo gec | sudo -S chown -hR hduser /home/hduser/hadoop/
sudo -u hduser echo gec | sudo -S chmod -R 777 /home/hduser/hadoop/