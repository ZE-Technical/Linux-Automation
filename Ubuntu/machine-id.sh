# Fix /etc/machine-id Clone IP issue 

# Access the network config file and change it's contence
vi /etc/netplan/*.yaml

network:
  version: 2
  renderer: networkd
  ethernets:
    default:
      match:
        name: e*
      dhcp4: yes
      dhcp-identifier: mac

# After this, convert the VM into a template and give it to Terraform to deploy clones with