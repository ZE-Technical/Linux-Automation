#!/bin/bash

# Fix /etc/machine-id Clone IP issue 

# Create variable pointing to network config file
file_to_edit="/etc/netplan/*.yaml"

# Change contents of network config file
sed -i 's/dhcp-identifier: machine-id/dhcp-identifier: mac/g' $file_to_edit

# After this, convert the VM into a template and give it to Terraform to deploy clones with unique IP addresses