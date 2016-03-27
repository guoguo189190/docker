#!/bin/bash
#used for  Install docker on ubuntu 14.04 LTS
#author aguang
#date 2016.03.08


#1. add the DNS
echo "nameserver 172.18.0.6" > /etc/resolv.conf
#2. Update your apt sources
#2.1 Update package information, ensure that APT works with the https method, and that CA certificates are installed
apt-get update -y  >  /dev/null 2>&1
apt-get install apt-transport-https ca-certificates -y >  /dev/null 2>&1
#2.2Add the new GPG key.
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#2.3.Add an entry for your Ubuntu operating system
touch  /etc/apt/sources.list.d/docker.list && echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
#2.4 Update the APT package index
apt-get update -y >  /dev/null 2>&1
#2.5 Purge the old repo if it exists.
apt-get purge lxc-docker >  /dev/null 2>&1
#2.6 Verify that APT is pulling from the right repository.
apt-cache policy docker-engine  >  /dev/null 2>&1

#3 Prerequisites by Ubuntu Version 
#3.1 Update your package manager
apt-get update -y >  /dev/null 2>&1
#3.2 Install the recommended package
apt-get install linux-image-extra-$(uname -r) -y >  /dev/null 2>&1
apt-get install apparmor -y >  /dev/null 2>&1

#4 Install 
apt-get update -y >  /dev/null 2>&1
apt-get install docker-engine -y >  /dev/null 2>&1

if (($?==0));then
   echo "docker install success"
else
   echo "docker install failed"
   exit 1
fi

service docker start
ps -ef | grep docker | grep -v 'grep'
if (($?==0));then
   echo "docker start success"
else
   echo "docker start failed"
   exit 1
fi

#5 Configure Docker to start on boot
apt-get install sysv-rc-conf  -y
sysv-rc-conf --level 2345 docker  on && echo 'start docker onboot success' || echo 'start docker onboot failed'

docker run hello-world
if (($?==0));then
   echo "docker can be used"
else
   echo "docker test faild ,check the images"
   exit 1
fi

exit 0
