#!/bin/bash

component=$1
sudo dnf install ansible -y

#cd /home/ec2-user
#git clone https://github.com/manoharialamuri/tf.ansible.roles.roboshop.git

cd tf.ansible.roles.roboshop

ansible-playbook -e component=$component roboshop.yaml

