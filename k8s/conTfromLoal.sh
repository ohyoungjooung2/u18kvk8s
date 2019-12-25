#!/usr/bin/env bash
#This simple script is for downloading kubectl binary and then configure to control kubernetes cluster from local pc,not k8s master node(laptop and etc)

if [[ ! -e $HOME/bin ]]
then
   mkdir $HOME/bin
else
   echo "$HOME/bin/ exists"
fi

KUB=$(which kubectl)
if [[ -z $KUB ]]
then
 echo -e "\e[35m Downloading kubectl from official..site \e[0m"
 curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
 mv kubectl $HOME/bin
 chmod 700 $HOME/bin/kubectl
else
 echo "kubectl already exists"
fi

if [[ ! -e $HOME/.kube ]]
then
   mkdir $HOME/.kube
else
   echo "kube directory already exists"
fi

echo "Direct into ~/.kube/config2"
#10.1.0.2 is master k8s nodes
ssh -i id_rsa vagrant@10.1.0.2 'sudo cat /etc/kubernetes/admin.conf' > ~/.kube/config2

echo "export KUBECONFIG=$HOME/.kube/config2" >> $HOME/.bashrc
$HOME/bin/kubectl get nodes

echo -e "\e[35m You do not need to login master k8s node every time! Congratula..! \e[0m"
exec bash
