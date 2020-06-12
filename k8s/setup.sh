#!/usr/bin/env bash
#Key check if not, generate
if [[ -e ./id_rsa ]]
then
   echo "Deleting previous id_rsa"
   rm -f ./id_rsa
fi

echo -e "\e[35m Generating ssh key for provisionng automatic \e[0m"
ssh-keygen -t rsa -f id_rsa -q -N '' >/dev/null
chmod 600 id_rsa

echo -e "\e[35m copy id_rsa.put to pub_key \e[0m"
mv id_rsa.pub pub_key

echo -e "\e[35m up master first \e[0m"
vagrant up kubemaster --provision;

#If exists admin_init.log already then rm
if [[ -e ./admin_init.log ]]
then
        echo -e "\e[35m rm admin_init.log first \e[0m"
	rm -fv ./admin_init.log
fi

#When the case that /vagrant directory mounted on local . directory in real time.(at once or never)
echo -e "\e[35m scp -i id_rsa vagrant@10.1.0.2:/vagrant/admin_init.log from kubemaster \e[0m"
#ssh-keygen -f "/home/oyj/.ssh/known_hosts" -R "10.1.0.2"
scp -i id_rsa -o "StrictHostKeyChecking=no" vagrant@10.1.0.2:/vagrant/admin_init.log ./

#scp success check
if [[ $? -eq 0 ]]
then
   echo "scp admin_inig.log success"
else
   echo "scp admin_init.log failed"
   exit 1
fi

schk(){
    if [[ $? -eq 0 ]]
    then
      echo "$1 success"
    else
      echo "$1 success"
    fi
}

while true
do
 t=$(ssh  -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i id_rsa vagrant@10.1.0.2 '/usr/bin/kubectl get no' | grep -i kubemaster | tail -1 | awk '{print $2}')
 if [[ $t == "Ready" ]]
 then
	 echo "Success of kubemaster initializing pods --all-namesaces"
	 echo "Staring kubeworker1"
         vagrant up kubeworker1
         schk kubeworker1
	 echo "Staring kubeworker2"
         vagrant up kubeworker2
         schk kubeworker2
	 exit 0
 else
         echo "Wait until kubemaster ready to accept nodes to join"
	 sleep 1
 fi
done


#vagrant up kubeworker1
#schk kubeworker1
#vagrant up kubeworker2
#schk kubeworker2
