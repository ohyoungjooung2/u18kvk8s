#!/usr/bin/env bash
#Nettools install
sudo yum -y install net-tools

VHOME="/home/vagrant"
KUSER="vagrant"
check_ok(){
  if [[ $? == "0" ]]
  then
     echo -e "\e[36m $1 job successful \e[0m"
  else
     echo -e "\e[33m $1 job failed \e[0m"
     exit 1
  fi
}
kubeadm_init_flannel(){
API_CHECK=$(sudo netstat -tpln | grep kube-api)
if [[ ! $API_CHECK ]]
then
  echo -e "\e[36m kubeadm init apiserver advertise and flannel pod network  \e[0m"
  sudo kubeadm init --apiserver-advertise-address=10.1.0.2 --pod-network-cidr=10.244.0.0/16 > /vagrant/admin_init.log
  sudo chown vagrant:vagrant /vagrant/admin_init.log
  check_ok kubeadm_init
else
  echo -e "\e[33m kubeadm init apiserver already running  \e[0m"
fi
}
kubeadm_user_env(){
if [[ (! -e $VHOME/.kube) || (! -e $VHOME/.kube/config)  ]]
then
  echo -e "\e[36m To start kubectl as a vagrant user \e[0m"
  mkdir -p $VHOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $VHOME/.kube/config
  sudo chown $(id -u):$(id -g) $VHOME/.kube/config
  sudo chown -R $KUSER:$KUSER $VHOME/
  check_ok kubeadm_user_env
else
  echo -e "\e[33m  kubectl as a vagrant user seems likely already exist \e[0m"
fi
}


kubeadm_pod_network_flannel(){
  #Url changes when k8s version changes 
  #URL117="https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml"
  URL="https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
  echo -e "\e[36m flannel pod apply \e[0m"
  #sudo su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml"
  sudo su - vagrant -c "/usr/bin/kubectl apply -f $URL"
  echo -e "\e[36m Wait untile pods are initialized \e[0m"
  sleep 30
  sudo su - vagrant -c "/usr/bin/kubectl get pods --all-namespaces"
}


kubeadm_init_flannel
kubeadm_user_env
kubeadm_pod_network_flannel
