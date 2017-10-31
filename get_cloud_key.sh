#!/bin/sh
# get cloud.pri
scp root@27.102.70.153:~/cloud.pri ~/
# use cloud key for ssh
echo "IdentityFile ~/cloud.pri" >> ~/.ssh/config
echo "StrictHostKeyChecking no" >> ~/.ssh/config
#

