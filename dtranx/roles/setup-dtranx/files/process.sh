#! /bin/bash
# designed by Ning Gao
#  three modes
# 	bind: for dtranx usage, bind I/O threads of dtranx to specific cores
#		I/O threads are the second and third threads of dtranx process
#	context: show context switches for all threads of a process
#	softirq: binding cpu cores for kernel side network softirq threads
#		when using softirq mode, using sudo
#	
if [[ "$#" < 2 ]]; then
	echo "arg1 mode: 'bind', 'context', 'softirq'"
	echo "the following are arguments for different modes"
	echo "bind: coreid"
	echo "context: pid, coreid"
	echo "softirq, rxcoreid, txcoreid"
	exit
fi

if [[ "$1" == "bind" ]];then
	if [[ "$#" < 2 ]];then
		echo "provide the coreid"
		exit
	fi
	pid=`ps -ef|grep DTranx|grep -v grep|awk '{print $2}'`
	index=0
	for file in "/proc/$pid/task"/*;do 
		tid=`basename $file`
		if [[ $index == "1" ]] || [[ $index == "2" ]];then
			taskset -p -c $2 $tid
		fi
		let index++
	done
elif [[ "$1" == "context" ]];then
	echo -e "index\ttid\t\tnon-voluntary-cs\tvoluntary-cs"
	index=0

	for file in "/proc/$2/task"/*;do 
		tid=`basename $file`
		voluntary=`cat /proc/$tid/status|cut -f 2|tail -n 2|awk 'NR == 1'`
		nonvoluntary=`cat /proc/$tid/status|cut -f 2|tail -n 2|awk 'NR == 2'`
		echo -e "$index\t$tid\t\t$nonvoluntary\t\t\t$voluntary"
		let index++
	done
elif [[ "$1" == "softirq" ]];then
	if [[ "$#" < 5 ]];then
		echo "another 4 arguments needed for softirq:"
		echo "ethernet id: e.g. eth2"
		echo "number of cpu"
		echo "provide two coreids, the first for rx queues and the second for tx queues"
		exit
	fi
	#bind the rx-queues to the same core for I/O thread
	service irqbalance stop
	cd /sys/class/net/$2/device/msi_irqs/;            
	for IRQ in *; do     
		echo $4 > /proc/irq/$IRQ/smp_affinity_list;             
	done
	# bind the tx-queue to the same core for peersend
	for CPU in $(seq 0 $[ $3 - 1 ]); do 
		let mask=$((1 << $5));     
		printf %X $mask > /sys/class/net/$2/queues/tx-$CPU/xps_cpus;
	done
fi




