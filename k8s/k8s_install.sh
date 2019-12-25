#!/usr/bin/env bash

if [[ ! -e /etc/yum.repos.d/kubernetes.repo ]]
then
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
else
  echo -e "\e[33m kubernetes.repo already installed \e[0m "
fi

#Selinux permissive level
setenforce 0


KLET=$(which kubelet)
KADM=$(which kubeadm)
KCTL=$(which kubectl)
if [[ ! $KLET || ! $KADM || ! $KCTL ]]
then
  yum install -y kubelet-1.17.0 kubeadm-1.17.0 kubectl-1.17.0
  systemctl enable kubelet && systemctl start kubelet
else
  echo -e "\e[33m kubelet kubeadm kubelet are already installed \e[0m "
fi



if [[ ! -e /etc/sysctl.d/k8s.conf ]]
then
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
else
  echo -e "\e[33m k8s.conf for net.bridge.bridg-nf-call-iptablese is already installed \e[0m "
  echo -e "\e[33m k8s.conf for net.bridge.bridg-nf-call-ip6tablese is already installed \e[0m "
fi
