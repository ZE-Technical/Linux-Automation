#!/bin/bash

# Import environment variables
source k3s_vars.sh

# Download and install K3s
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" K3S_URL=https://$NGINX_SERVER_IP:6443 K3S_TOKEN=$K3S_TOKEN sh -

# Start the K3s service
sudo systemctl start k3s-agent.service

# Check if the K3s service is running
SERVICE_NAME="k3s-agent.service"

if ! systemctl is-active --quiet "$SERVICE_NAME"; then
  systemctl start "$SERVICE_NAME"
  echo "Started $SERVICE_NAME"
else
  echo "$SERVICE_NAME is already running"
fi