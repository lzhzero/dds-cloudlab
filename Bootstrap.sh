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
	if [[ -z $prikeyPath ]];then
		prikeyPath="$HOME/.ssh/cloudlab.pri"
	fi
	rsync -avz ../dds-cloudlab --exclude .git $remoteIP:~/
	rsync $prikeyPath $remoteIP:~/
	echo "Complete"
elif [ $1 == "local" ];then
	echo "IdentityFile ~/cloudlab.pri" >> ~/.ssh/config
	echo "StrictHostKeyChecking no" >> ~/.ssh/config
	echo "Complete"
else
	echo "args: remote/local"
fi
