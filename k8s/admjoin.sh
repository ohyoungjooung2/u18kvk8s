#!/usr/bin/env bash
NETS=$(which netstat)
if [[ ! $NETS ]]
then
  sudo yum -y install net-tools
else
 echo "netstat net-tools already installed"
fi


NETCHECK=$(sudo $NETS -tpln | grep 10250)
if [[ $NETCHECK ]]
then
  echo -e "\e[33m Seems like this node already joined \e[0m"
else
  sudo scp -o StrictHostKeyChecking=no -i /home/vagrant/.ssh/id_rsa vagrant@10.1.0.2:/vagrant/admin_init.log /vagrant/
  echo -e "\e[36m Node will join with master 10.1.0.2 \e[0m"
  #JOINC=$(ssh -o StrictHostKeyChecking=no -i /home/vagrant/.ssh/id_rsa vagrant@10.1.0.2 'cat /vagrant/admin_init.log | grep "kubeadm join 10.1.0.2:6443"')
  JOINC=$(cat /vagrant/admin_init.log | tail -2 | sed 's/\\//g')
  sudo $JOINC
fi   
