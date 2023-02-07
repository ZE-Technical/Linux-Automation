#!/bin/bash

# Import environment variables
source k3s_vars.sh

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

# Run a test to verify kubectl works (MUST WORK)
kubectl --kubeconfig ~/.kube/config get nodes --all-namespaces

# Install HELM package manager for Kubernetes
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

#Make HELM installation script executable
chmod 700 get_helm.sh

# Run HELM installtion script
./get_helm.sh

# Download Rancher stable repository to HELM
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

# Update HELM repository 
helm repo update

# Create a namespace for Rancher
kubectl create namespace cattle-system

# Install cert-manager for kubernetes
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml

# Add Jetstack to HELM repo
helm repo add jetstack https://charts.jetstack.io

# Update HELM repo
helm repo update

# Install cert-manager HELm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.1

# Install Rancher with HELM
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=$NGINX_SERVER_DNS \
  --set replicas=3

# Get status of Rancher Roll-out
kubectl -n cattle-system rollout status deploy/rancher