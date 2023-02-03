#!/bin/bash

# Fix /etc/machine-id Clone IP issue 

# Create variable pointing to network config file
file_to_edit="/etc/netplan/*.yaml"
new_content="network:
  version: 2
  renderer: networkd
  ethernets:
    default:
      match:
        name: e*
      dhcp4: yes
      dhcp-identifier: mac"

# Change contents of network config file
echo -n "" > "$file_to_edit"
echo "$new_content" >> "$file_to_edit"

# After this, convert the VM into a template and give it to Terraform to deploy clones with unique IP addresses