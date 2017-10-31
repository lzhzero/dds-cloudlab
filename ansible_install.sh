#!/bin/sh
# get cloud.key
scp root@27.102.70.153:~/cloud.key ~/
# use cloud key for ssh
echo "IdentityFile ~/cloud.key" >> ~/.ssh/config
echo "StrictHostKeyChecking no" >> ~/.ssh/config
#

# prepare environment
sudo apt install -y python-pip python-dev python-software-properties software-properties-common curl

sudo pip install Jinja2==2.7.2 MarkupSafe==0.11

sudo add-apt-repository -y ppa:ansible/ansible
sudo apt -y update
sudo apt -y install ansible

#git clone -b release-1.0 https://github.com/pingcap/tidb-ansible.git
