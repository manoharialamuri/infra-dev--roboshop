#!/bin/bash

component=$1
sudo dnf install ansible -y

cd /home/ec2-user
git clone https://github.com/manoharialamuri/tf.ansible.roles.roboshop.git

cd tf.ansible.roles.roboshop
git pull
ansible-playbook -e component=$component roboshop.yaml

# create vault password file

mkdir -p /home/ec2-user/.ansible

echo "DevOps321" > /home/ec2-user/.ansible/.mysql_vault_password

chmod 600 /home/ec2-user/.ansible/.mysql_vault_password