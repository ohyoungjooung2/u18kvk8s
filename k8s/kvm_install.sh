#!/usr/bin/env bash

#kvm-ok (cpu-checker instlal)
CHECK_KOK=$(which kvm-ok)
if [[ $?=!"0" ]]
then
  sudo apt install -y cpu-checker
else
  echo "kvm-ok(cpu-checker) installed"
fi


kvm-ok > /dev/null 2>&1

if [[ $?=="0" ]]
then
   echo "Using kvm is possible"
   echo "Installing kvm related packages!"
   sudo apt install -y qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager 
   echo "Enabling libvirtd service"
   sudo systemctl enable libvirtd
   echo "Stargint libvirtd service" 
   sleep 1
   sudo systemctl start libvirtd
else
   echo "kvm is disabled"
   exit 1
fi


#Check libvirtd
ps -ef | grep libvirtd | grep -v grep
exit 0
