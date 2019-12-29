# kvm-vagrant-docker-k8s-config
 This vagrant Vagrantfile and setup will consist of k8s dev setup.
 
 Just bash setup.sh will do the work.

Example)


user@host$ bash setup.sh

Please keep in mind:
Warning.

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 Never use this in production env. This repo container id_rsa ,which is private key just for convenience.

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


Log in "vagrant ssh kubemaster" after vagrant up finished.

$kubectl get nodes #this command will show three nodes !

ex)
```oyj@oyj-laptop:~/kvm-vagrant-docker-k8s-config$ vagrant ssh kubemaster
Last login: Wed Apr  3 18:24:24 2019


[vagrant@kubemaster ~]$ kubectl get nodes

NAME          STATUS     ROLES    AGE    VERSION
kubemaster    Ready      master   13m    v1.14.0
kubeworker1   NotReady   <none>   105s   v1.14.0
kubeworker2   NotReady   <none>   96s    v1.14.0```


```[vagrant@kubemaster ~]$ kubectl get nodes


NAME          STATUS   ROLES    AGE     VERSION
kubemaster    Ready    master   13m     v1.14.0
kubeworker1   Ready    <none>   2m28s   v1.14.0
 kubeworker2   Ready    <none>   2m19s   v1.14.0```


```[vagrant@kubemaster ~]$ kubectl get pods --all-namespaces

NAMESPACE     NAME                                 READY   STATUS    RESTARTS   AGE

kube-system   coredns-fb8b8dccf-kj9db              1/1     Running   0          13m
kube-system   coredns-fb8b8dccf-rtds2              1/1     Running   0          13m
kube-system   etcd-kubemaster                      1/1     Running   0          12m
kube-system   kube-apiserver-kubemaster            1/1     Running   0          13m
kube-system   kube-controller-manager-kubemaster   1/1     Running   0          13m
kube-system   kube-flannel-ds-amd64-69rpq          1/1     Running   0          13m
kube-system   kube-flannel-ds-amd64-smxnn          1/1     Running   0          2m53s
kube-system   kube-flannel-ds-amd64-tmcbl          1/1     Running   0          2m44s
kube-system   kube-proxy-5zhrl                     1/1     Running   0          13m
kube-system   kube-proxy-96qxc                     1/1     Running   0          2m53s
kube-system   kube-proxy-dfddc                     1/1     Running   0          2m44s
kube-system   kube-scheduler-kubemaster            1/1     Running   0          13m```

