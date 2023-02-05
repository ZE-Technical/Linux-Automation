#!/bin/bash

# Import environment variables
source k3s_vars.sh

# Export remote datastore endpoint so k3s knows where to look during installation
export K3S_DATASTORE_ENDPOINT="mysql://$MYSQL_USER:$MYSQL_PASSWORD@tcp($MYSQL_IP:3306)/$MYSQL_DB"

# Download and install K3s
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" sh -s - agent

# Start the K3s service
sudo systemctl start k3s.service

# Check if the K3s service is running
sudo systemctl status k3s.service