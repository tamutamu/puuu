#!/bin/bash
set -Ceuo pipefail


sudo apt update
sudo apt -y install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt -y install ansible

sudo apt -y install python3-pip
sudo pip install pexpect
