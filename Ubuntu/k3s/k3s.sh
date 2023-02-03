#!/bin/bash

# Download and install K3s
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.24.10+k3s1" sh -s - server \
  --datastore-endpoint="mysql://mysqluser:HappySlappy123!@tcp(hostname:3306)/database-name"
# Start the K3s service
sudo systemctl start k3s

# Check if the K3s service is running
sudo systemctl status k3s