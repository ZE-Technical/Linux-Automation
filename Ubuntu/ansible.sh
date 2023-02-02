#!/bin/bash

# Update the package list
sudo apt update

# Install dependencies
sudo apt install software-properties-common -y

# Add the Ansible PPA
sudo apt-add-repository ppa:ansible/ansible -y

# Update the package list again to pick up the new repository information
sudo apt update

# Install the latest version of Ansible
sudo apt install ansible -y

# Verify the installation
ansible --version