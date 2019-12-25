#!/usr/bin/env bash

DOCKER=`which docker`
#Stable docker version
STABDV="18.06.0-ce"
INSTALLED_DOCKER_VERSION=$($DOCKER -v | awk -F"," '{ print $1 }' | awk '{print $3}')

remove_docker(){
  sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
}


repo_setup(){
  sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2;
  sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo;
}

install_docker(){
    #sudo yum -y install docker-ce
    sudo yum -y install docker-ce
}

start_docker(){
    sudo systemctl enable docker
    sudo systemctl start docker
    sleep 1
    sudo docker run hello-world
}

docker_install_check(){
 #CHECK=$(rpm -qa | grep -i docker)
 CHECK=$($DOCKER -v 2> /dev/null)
 #declare -a DOCKER_OLD=($CHECK)
 if [[ $CHECK && ($STABDV != $INSTALLED_DOCKER_VERSION ) ]]
 then
   remove_docker
 elif [[ $STABDV == $INSTALLED_DOCKER_VERSION ]]
 then

   echo -e "Installed docker version is same as $STABDV \e[31m $CHECK \e[0m "
 else
   echo "NO docker installed"
   repo_setup
   install_docker
   start_docker
 fi
}



docker_install_check
