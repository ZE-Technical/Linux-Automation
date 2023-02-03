#!/bin/bash

# Import group variables
. rke2_vars.sh

# Create directory for RKE2 config to be placed
mkdir -p /etc/rancher/rke2/

# Create the RKE2 config file
token: $MY_SHARED_SECRET
    server: https://<DNS-DOMAIN>:9345
    tls-san:
      - my-kubernetes-domain.com
      - another-kubernetes-domain.com

# Install RKE2 packages
curl -sfL https://get.rke2.io | INSTALL_K3S_VERSION="v1.24.10+k3s1" sh -

# Enable RKE2 service
systemctl enable rke2-server.service

# Start RKE2 service
systemctl start rke2-server.service