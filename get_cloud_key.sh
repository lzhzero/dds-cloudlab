#!/bin/sh
# get cloud.pri
scp root@27.102.70.153:~/cloud.key ~/
# use cloud key for ssh
echo "IdentityFile ~/cloud.key" >> ~/.ssh/config
echo "StrictHostKeyChecking no" >> ~/.ssh/config
#

