Pre-Requisite  
* Cloudlab image: 
Dependent libraries such as protobuf, unwind, crypto, profiler, boost, metis, leveldb, tcmalloc. details are in wiki pages.   
Our projects installation: zeromq, logcabin, pmem, dtranx.  
Kernel is modified to support PMEM.   
Open file limit is adjusted.  
Files are copied: ansible installation files.  
* Note: private key is not there yet.  

Files: for each project, a directory is created.
* dtranx/  
* hyperdex/  
* bangdb/  
* ycsbc/  
* Bootstrap.sh: 

Steps:
* Run Bootstrap.sh in both two modes
* Update the ip addresses of the cluster servers in inventory.ini
* Run ansible scripts in the cluster
```
		ansible-playbook *.yml
```

Copyright (c) 2017 University of Colorado Boulder. All rights reserved.  
Developed by:  
Zhang Liu(zhang.liu@colorado.edu)  
Ning Gao(nigo9731@colorado.edu)  
