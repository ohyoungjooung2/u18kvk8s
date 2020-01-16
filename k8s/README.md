#Intro
This git shows how to install k8s using kvm+libvirt+vagrant+k8s on ubunt18.04(xubuntu desktop).

After git clone like below.


```oyj@oyj-X555QG:~$ git clone https://github.com/ohyoungjooung2/u18kvk8s.git

```


1. Install kvm and libvirt
```

 ```oyj@oyj-X555QG:~/u18kvk8s/k8s$ bash kvm_install.sh ```
 ```

2. Install vagrant
```
oyj@oyj-X555QG:~/u18kvk8s/k8s$ bash vagrant_install.sh 
```

3. user id into kvm and libvirt
```
oyj@oyj-X555QG:~/u18kvk8s/k8s$ sudo adduser `id -un` kvm
oyj@oyj-X555QG:~/u18kvk8s/k8s$ sudo adduser `id -un` libvirt

oyj@oyj-X555QG:~/u18kvk8s/k8s$ sudo su - $USER
oyj@oyj-X555QG:~$ cd ~/u18kvk8s/k8s/
oyj@oyj-X555QG:~/u18kvk8s/k8s$ bash setup.sh 


```
