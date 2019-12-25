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

kubeadm_init(){
API_CHECK=$(netstat -tpln | grep kube-api)
if [[ ! $API_CHECK ]]
then
  echo -e "\e[36m kubeadm init apiserver advertise and pod network  \e[0m"
  sudo kubeadm init --apiserver-advertise-address=10.1.0.2 --pod-network-cidr=172.16.0.0/16 > /vagrant/admin_init.log
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

kubeadm_pod_network(){
  echo -e "\e[36m kube-proxy pod apply \e[0m"
  #sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml


  sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml
  check_ok kube-proxy-pod-apply

  echo -e "\e[36m kube-proxy default delete \e[0m"
  echo -e "\e[37m Now since kube-router provides service proxy as well. Run below commands to remove kube-proxy and cleanup any iptables configuration it may have done. \e[0m"
  sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl -n kube-system delete ds kube-proxy
  check_ok kube-rouer-default-delete

  echo -e "\e[36m kube-proxy new adjust\e[0m"
  sudo  docker run --privileged --net=host k8s.gcr.io/kube-proxy-amd64:v1.10.2 kube-proxy --cleanup
  check_ok docker_run_kube-proxy-new-adjust

  echo -e "\e[36m kubectl get pods --all-namespaces \e[0m"
  #sudo su - vagrant -c "kubectl get pods --all-namespaces"
  sleep 10
  sudo su - vagrant -c "kubectl get pods --all-namespaces"
}

kubeadm_init
kubeadm_user_env
kubeadm_pod_network
