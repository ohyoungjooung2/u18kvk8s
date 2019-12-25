#!/usr/bin/env bash

DOCKER=`which docker`
#Stable docker version for k8s
STABDV="18.06.2.ce"
if [[ $DOCKER ]]
then
 INSTALLED_DOCKER_VERSION=$($DOCKER -v | awk -F"," '{ print $1 }' | awk '{print $3}' 2> /dev/null)
fi

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
  lvm2 \
  libcgroup  \
  policycoreutils-python \
  libtool-ltdl;

  #When docker-ce.repo not exists
  if [[ ! -e /etc/yum.repo.d/docker-ce.repo ]]
  then
  sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo;
  fi
}

install_docker(){
    #sudo yum -y --setopt=obsoletes=0 install docker-ce-selinux-$STABDV-1.el7.centos docker-ce-$STABDV-1.el7.centos
    sudo yum -y --setopt=obsoletes=0 install docker-ce-selinux-$STABDV docker-ce-$STABDV
    ## Create /etc/docker directory.
    mkdir /etc/docker
    #https://kubernetes.io/docs/setup/production-environment/container-runtimes/
    # Setup daemon.
cat > /etc/docker/daemon.json <<EOF
    {
      "exec-opts": ["native.cgroupdriver=systemd"],
      "log-driver": "json-file",
      "log-opts": {
        "max-size": "100m"
      },
      "storage-driver": "overlay2",
      "storage-opts": [
        "overlay2.override_kernel_check=true"
      ]
    }
EOF
    mkdir -p /etc/systemd/system/docker.service.d

}

start_docker(){
    sudo systemctl enable docker
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sleep 1
    sudo docker run hello-world
}

restart_docker(){
    sudo systemctl restart docker
}

docker_install_check(){
 #CHECK=$(rpm -qa | grep -i docker)
 CHECK=$($DOCKER -v 2> /dev/null)
 #declare -a DOCKER_OLD=($CHECK)
 #When STABDV IS NOT SAME AS INSTALLED VERSION, INSTALL DOCKER VERSION OF $STABDV
 if [[ $CHECK && ($STABDV != $INSTALLED_DOCKER_VERSION ) ]]
 then
   repo_setup
   remove_docker
   install_docker
   restart_docker
 elif [[ $STABDV == $INSTALLED_DOCKER_VERSION ]]
 then

   echo -e "Installed docker version for kubernets is compliant with current kubernet. Version is $STABDV == \e[31m $CHECK \e[0m OK!"
 else
   echo "NO docker installed"
   repo_setup
   install_docker
   start_docker
 fi
}


docker_install_check
