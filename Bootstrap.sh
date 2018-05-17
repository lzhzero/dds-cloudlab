#TODO: put related src dirs on remote node.


# Bootstrap.sh prepares the cluster before ansible scripts are run.
# It consists of two setps. First, run Bootstrap.sh in remote mode from outside the cluster and chooses
# one ansible master server in the cluster. Second, run it in local mode in the ansible master.
# 	remote mode: remote: copy the project and private keys to one server in the cluster  
#	local mode: prepare the server in the cluster

LogcabinDir=
DTranxDir=
YCSBCDir=

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

	echo "Copy dtranx related files, skip(y/n):"
	read skip
	if [ $skip == "n" ];then
		ssh -i $prikeyPath $remoteIP "mkdir -p ~/DTranx/include"
		ssh -i $prikeyPath $remoteIP "mkdir -p ~/DTranx/Build"
		echo "input DTranx directory:(default: ../DTranx)"
		read DTranxDir
		eval DTranxDir=$DTranxDir
		if [[ -z $DTranxDir ]];then
			DTranxDir="../DTranx/"
		fi
		scp -i $prikeyPath -r $DTranxDir/Build/libdtranx.a $remoteIP:~/DTranx/Build/
		scp -i $prikeyPath -r $DTranxDir/Build/libdtranx.so $remoteIP:~/DTranx/Build/
		scp -i $prikeyPath -r $DTranxDir/Build/DTranx $remoteIP:~/DTranx/Build/
	fi

	echo "Copy logcabin related files, skip(y/n):"
	read skip
	if [ $skip == "n" ];then
		ssh -i $prikeyPath $remoteIP "mkdir -p ~/Logcabin/build"
		echo "input Logcabin directory:(default: ../Logcabin)"
		read LogcabinDir
		eval LogcabinDir=$LogcabinDir
		if [[ -z $LogcabinDir ]];then
			LogcabinDir="../Logcabin/"
		fi
		scp -i $prikeyPath -r $LogcabinDir/build/liblogcabin.a $remoteIP:~/Logcabin/build/
		scp -i $prikeyPath -r $LogcabinDir/build/liblogcabin.so $remoteIP:~/Logcabin/build/
		scp -i $prikeyPath -r $LogcabinDir/build/LogCabin $remoteIP:~/Logcabin/build/
	fi

	echo "Copy BTree related files, skip(y/n):"
	read skip
	if [ $skip == "n" ];then
		ssh -i $prikeyPath $remoteIP "mkdir -p ~/BTree/build"
		echo "input BTree directory:(default: ../BTree)"
		read BTreeDir
		eval BTreeDir=$BTreeDir
		if [[ -z $BTreeDir ]];then
			BTreeDir="../BTree/"
		fi
		scp -i $prikeyPath -r $BTreeDir/Build/libbtree.a $remoteIP:~/BTree/build/
		scp -i $prikeyPath -r $BTreeDir/Build/libbtree.so $remoteIP:~/BTree/build/
	fi

	echo "Copy RTree related files, skip(y/n):"
	read skip
	if [ $skip == "n" ];then
		ssh -i $prikeyPath $remoteIP "mkdir -p ~/RTree/build"
		echo "input RTree directory:(default: ../RTree)"
		read RTreeDir
		eval RTreeDir=$RTreeDir
		if [[ -z $RTreeDir ]];then
			RTreeDir="../RTree/"
		fi
		scp -i $prikeyPath -r $RTreeDir/Build/librtree.a $remoteIP:~/RTree/build/
		scp -i $prikeyPath -r $RTreeDir/Build/librtree.so $remoteIP:~/RTree/build/
	fi

	echo "Copy ycsbc related files, skip(y/n):"
	read skip
	if [ $skip == "n" ];then
		ssh -i $prikeyPath $remoteIP "mkdir -p ~/YCSB-C-DTranx"
		echo "input YCSBC directory:(default: ../YCSB-C-DTranx)"
		read YCSBCDir
		eval YCSBCDir=$YCSBCDir
		if [[ -z $YCSBCDir ]];then
			YCSBCDir="../YCSB-C-DTranx"
		fi
		scp -i $prikeyPath -r $YCSBCDir/ycsbc $remoteIP:~/YCSB-C-DTranx/
		scp -i $prikeyPath -r $YCSBCDir/workloads/*.spec $remoteIP:~/YCSB-C-DTranx/
	fi

	echo "Copy missing libs, skip(y/n):"
	read skip
	if [ $skip == "n" ];then
		ssh -i $prikeyPath $remoteIP "mkdir -p ~/libs/"
		echo "input library directory:(default: ../libs)"
		read LibDir
		eval LibDir=$LibDir
		if [[ -z $LibDir ]];then
			LibDir="../libs"
		fi
		scp -i $prikeyPath -r $LibDir/libbangdb-client* $remoteIP:~/libs/
		scp -i $prikeyPath -r $LibDir/libbusybee* $remoteIP:~/libs/
		scp -i $prikeyPath -r $LibDir/libe* $remoteIP:~/libs/
		scp -i $prikeyPath -r $LibDir/libhyperdex* $remoteIP:~/libs/
		scp -i $prikeyPath -r $LibDir/libmacaroons* $remoteIP:~/libs/
		scp -i $prikeyPath -r $LibDir/libpqxx* $remoteIP:~/libs/
		scp -i $prikeyPath -r $LibDir/libreplicant* $remoteIP:~/libs/
		scp -i $prikeyPath -r $LibDir/libsodium* $remoteIP:~/libs/
		scp -i $prikeyPath -r $LibDir/libtreadstone* $remoteIP:~/libs/
		echo "Complete"
	fi
elif [ $1 == "local" ];then
	echo "IdentityFile ~/cloudlab.pri" >> ~/.ssh/config
	echo "StrictHostKeyChecking no" >> ~/.ssh/config
	echo "Complete"
else
	echo "args: remote/local"
fi
