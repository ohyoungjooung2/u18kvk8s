#!/usr/bin/env bash
which curl
if [[ $? -eq 0 ]]
then
  echo "curl already installed"
else
  sudo apt install -y curl
fi

if [[ ! -e ./vagrant225.deb ]]
then
  VFILE="https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_x86_64.deb"
  curl -o vagrant225.deb $VFILE
else
  echo "vagrant225.deb already downloaded"
fi

#sha256 check
#https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_SHA256SUMS
SH256="415f50b93235e761db284c761f6a8240a6ef6762ee3ec7ff869d2bccb1a1cdf7"
SH256FILE=$(/usr/bin/sha256sum vagrant225.deb | awk '{print $1}')


if [[ $SH256==$SHA256FILE ]]
then
    if [[ -e /usr/bin/vagrant ]]
    then
      VAGRANT_VCHK=$(/usr/bin/vagrant --version | awk '{print $2}')
      echo "Vagrant 2.2.5 already installed"
    else
      sudo /usr/bin/dpkg -i vagrant225.deb
    fi
else
    echo "Something is wrong. It would be wrong sha256"
fi


#plugin install 
#First dependencies install(https://github.com/vagrant-libvirt/vagrant-libvirt#installation)
sudo apt-get build-dep -y vagrant ruby-libvirt
sudo apt-get install -y qemu libvirt-bin ebtables dnsmasq-base
sudo apt-get install -y libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev

#Plugin install last
/usr/bin/vagrant plugin install vagrant-libvirt

#Plugin check
if [[ $? -eq 0 ]]
then
  /usr/bin/vagrant plugin list | grep libvirt
fi


sudo apt autoremove -y
exit 0
