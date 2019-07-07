#!/bin/bash

echo "Installing ansible ........"
sudo amazon-linux-extras install ansible2 -y
echo "Installing python2-pip"
sudo yum install python2-pip -y
echo "Installing boto"
sudo pip install boto
echo "Installing terraform 0.11.8"
wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
sudo unzip terraform_0.11.8_linux_amd64.zip -d /usr/local/sbin
echo Iinitializing terraform"
terraform init
