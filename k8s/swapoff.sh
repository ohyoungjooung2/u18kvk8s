#!/usr/bin/env bash
#Which swap off
SOFF=$(which swapoff)

SED=$(which sed)
#Swapoff on kubemaster
SP=$(cat /etc/fstab | grep -i swap | awk '{print $1}')
$SOFF $SP

#SP comment
TODAY=$(date +%Y-%m-%d)
SPN=$(cat -n /etc/fstab | grep -i swap | awk '{print $1}')
$SED -i.$TODAY -e "${SPN}s/^/#/" /etc/fstab


