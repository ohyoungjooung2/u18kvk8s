#!/usr/bin/env bash
KEY=$(cat /vagrant/pub_key)
VMKEY=$(cat /home/vagrant/.ssh/authorized_keys | tail -1)
if [[ $KEY != $VMKEY ]]
then
	echo "copying $KEY to vms"
 echo $KEY >> /home/vagrant/.ssh/authorized_keys
else
 echo -e "\e [33m $KEY ALREADY INSTALLED \e[0m "
fi 
sudo yum -y install telnet net-tools wget 
