#TODO: put related src dirs on remote node.


# Bootstrap.sh prepares the cluster before ansible scripts are run.
# It consists of two setps. First, run Bootstrap.sh in remote mode from outside the cluster and chooses
# one ansible master server in the cluster. Second, run it in local mode in the ansible master.
# 	remote mode: remote: copy the project and private keys to one server in the cluster  
#	local mode: prepare the server in the cluster
if [[ "$#" -ne 1 ]];then
	echo "args: remote/local"
	exit
fi
if [ $1 == "remote" ];then
	echo "input remote server ip:"
	read remoteIP
	echo "input local private key path:(default: ~/.ssh/cloudlab.pri)"
	read prikeyPath
	eval prikeyPath=$prikeyPath
	if [[ -z $prikeyPath ]];then
		prikeyPath="$HOME/.ssh/cloudlab.pri"
	fi
	rsync -avz -e "ssh -i $prikeyPath" ../dds-cloudlab --exclude .git $remoteIP:~/
	scp -i $prikeyPath $prikeyPath $remoteIP:~/cloudlab.pri

	echo "Copy dtranx related files"
	ssh -i $prikeyPath $remoteIP "mkdir -p ~/DTranx/include"
	ssh -i $prikeyPath $remoteIP "mkdir -p ~/DTranx/Build"
	scp -i $prikeyPath -r ../DTranx/include/DTranx $remoteIP:~/DTranx/include/
	scp -i $prikeyPath -r ../DTranx/Build/libdtranx.a $remoteIP:~/DTranx/Build/
	scp -i $prikeyPath -r ../DTranx/Build/libdtranx.so $remoteIP:~/DTranx/Build/
	scp -i $prikeyPath -r ../DTranx/Build/DTranx $remoteIP:~/DTranx/Build/

	echo "Copy logcabin related files"

	ssh -i $prikeyPath $remoteIP "mkdir -p ~/Logcabin/Client"
	ssh -i $prikeyPath $remoteIP "mkdir -p ~/Logcabin/RPC/zeromq"
	ssh -i $prikeyPath $remoteIP "mkdir -p ~/Logcabin/build"
	scp -i $prikeyPath -r ../Logcabin/Client/Client.h $remoteIP:~/Logcabin/Client/
	scp -i $prikeyPath -r ../Logcabin/Client/ClientDataStructure.h $remoteIP:~/Logcabin/Client/
	scp -i $prikeyPath -r ../Logcabin/Client/DataStore.h $remoteIP:~/Logcabin/Client/
	scp -i $prikeyPath -r ../Logcabin/Client/KDTree.h $remoteIP:~/Logcabin/Client/
	scp -i $prikeyPath -r ../Logcabin/RPC/DaemonSendHelper.h $remoteIP:~/Logcabin/RPC/
	scp -i $prikeyPath -r ../Logcabin/RPC/zeromq/ZeromqDaemonSend.h $remoteIP:~/Logcabin/RPC/zeromq/
	scp -i $prikeyPath -r ../Logcabin/build/liblogcabin.a $remoteIP:~/Logcabin/build/
	scp -i $prikeyPath -r ../Logcabin/build/liblogcabin.so $remoteIP:~/Logcabin/build/
	scp -i $prikeyPath -r ../Logcabin/build/LogCabin $remoteIP:~/Logcabin/build/

	echo "Copy ycsbc related files"

	ssh -i $prikeyPath $remoteIP "mkdir -p ~/YCSB-C-DTranx"
	scp -i $prikeyPath -r ../YCSB-C-DTranx/ycsbc $remoteIP:~/YCSB-C-DTranx/
	scp -i $prikeyPath -r ../YCSB-C-DTranx/workloads/*.spec $remoteIP:~/YCSB-C-DTranx/
	
	echo "Copy missing libs"
	ssh -i $prikeyPath $remoteIP "mkdir -p ~/libs/"
	scp -i $prikeyPath -r ../libs/* $remoteIP:~/libs/
	echo "Complete"


elif [ $1 == "local" ];then
	echo "IdentityFile ~/cloudlab.pri" >> ~/.ssh/config
	echo "StrictHostKeyChecking no" >> ~/.ssh/config
	echo "Complete"
else
	echo "args: remote/local"
fi
