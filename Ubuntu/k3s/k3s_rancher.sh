#!/bin/bash

# Download kubectl binary on local workstation to configure and manage K3s cluster
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Download kubectl checksum
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# Verify kubectl binary integrity with checksum
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Copy kubeconfig file from K3s node to ~/.kube/config
K3S_SERVER_IP=""

scp ubuntu@$K3S_SERVER_IP:/etc/rancher/k3s/k3s.yaml ~/.kube/config

# Append .kube/config file server section with the IP and socket of Loadbalancer server
sudo sed -i 's/server: /sever: '$NGINX_SERVER_IP':6443/n' ~/.kube/config

# 