#!/bin/bash

component=$1
enviornment=$2
sudo dnf install ansible -y

cd /home/ec2-user
git clone https://github.com/manoharialamuri/tf.ansible.roles.roboshop.git

cd tf.ansible.roles.roboshop
git pull
ansible-playbook -e component=$component -e enviornment=$enviornment roboshop.yaml
