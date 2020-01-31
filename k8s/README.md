# Intro
This git shows how to install k8s using kvm+libvirt+vagrant+k8s on ubunt18.04(xubuntu desktop).

After git clone like below.

```oyj@oyj-X555QG:~$ git clone https://github.com/ohyoungjooung2/u18kvk8s.git

```
1. Install kvm and libvirt
```

 oyj@oyj-X555QG:~/u18kvk8s/k8s$ bash kvm_install.sh ```
 ```

2. Install vagrant
```
oyj@oyj-X555QG:~/u18kvk8s/k8s$ bash vagrant_install.sh 
```

3. user id into kvm and libvirt group

```
oyj@oyj-X555QG:~/u18kvk8s/k8s$ sudo adduser `id -un` kvm
oyj@oyj-X555QG:~/u18kvk8s/k8s$ sudo adduser `id -un` libvirt

oyj@oyj-X555QG:~/u18kvk8s/k8s$ sudo su - $USER
oyj@oyj-X555QG:~$ cd ~/u18kvk8s/k8s/
oyj@oyj-X555QG:~/u18kvk8s/k8s$ bash setup.sh 
..............................
 kubeworker2: [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    kubeworker2: [kubelet-start] Starting the kubelet
    kubeworker2: [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
    kubeworker2: 
    kubeworker2: This node has joined the cluster:
    kubeworker2: * Certificate signing request was sent to apiserver and a response was received.
    kubeworker2: * The Kubelet was informed of the new secure connection details.
    kubeworker2: 
    kubeworker2: Run 'kubectl get nodes' on the control-plane to see this node join the cluster.


```

4. Log in to kubemaster

```
oyj@oyj-X555QG:~/u18kvk8s/k8s$ vagrant ssh kubemaster
Last login: Thu Jan 16 13:30:17 2020
[vagrant@kubemaster ~]$ kubectl get no
NAME          STATUS   ROLES    AGE     VERSION
kubemaster    Ready    master   15m     v1.17.0
kubeworker1   Ready    <none>   6m6s    v1.17.0
kubeworker2   Ready    <none>   3m22s   v1.17.0

```

# Conclusion.
It is not yet mature enough but it will be useful.

