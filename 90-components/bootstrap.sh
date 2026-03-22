#!/bin/bash

component=$1
environment=$2
app_version=$3
sudo dnf install ansible -y

cd /home/ec2-user
git clone https://github.com/manoharialamuri/tf.ansible.roles.roboshop.git

cd tf.ansible.roles.roboshop
git pull
ansible-playbook -e component=$component -e env=$environment -e app_version=$app_version roboshop.yaml
