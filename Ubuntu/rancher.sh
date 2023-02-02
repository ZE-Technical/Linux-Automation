#!/bin/bash

# Define IP address of K3s Node

LINUX_SERVER_IP="192.168.127.129"

# Install Dependencies (kubectl)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Dependencies (helm)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh

sudo ./get_helm.sh

# Save kubeconfig to your workstation
scp root@$LINUX_SERVER_IP:/etc/rancher/k3s/k3s.yaml ~/.kube/config

# Edit the rancher server URL in kubeconfig
sed -i 's/127.0.0.1:6443/'$LINUX_SERVER_IP':6443/g' ~/.kube/config

# Add the Rancher charts repository
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

# Create a namespace for Rancher
kubectl create namespace cattle-system

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml

helm repo add jetstack https://charts.jetstack.io

# Update the Helm repository
helm repo update

# Install Rancher using Helm
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.1

# Wait for Rancher to be ready
kubectl -n cattle-system rollout status deploy/rancher

# Get the Rancher URL
echo "Rancher URL: http://rancher.example.com"