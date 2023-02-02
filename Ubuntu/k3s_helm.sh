#!/bin/bash

# Download and install K3s
curl -sfL https://get.k3s.io | sh -

# Start the K3s service
sudo systemctl start k3s

# Check if the K3s service is running
sudo systemctl status k3s

# Download the Helm installation script
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh

# Make the script executable
chmod +x get_helm.sh

# Run the script to install Helm
./get_helm.sh

# Verify that Helm is installed and working
helm version