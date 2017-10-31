pre-requisite
	Cloudlab image: DTranx library, YCSB library, ansible installation files
	Note: private key is not there yet.

structure: for each project, a directory is created.
	dtranx/
	hyperdex/
	bangdb/
	ycsbc/
	Bootstrap.sh
		remote: copy the project and private keys to one machine in the cluster
		local: run in the cluster machine to set things up.
