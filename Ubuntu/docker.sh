#!/bin/bash

# Update apt package repository
apt-get update

# Upgrade outdated packages
apt-get upgrade -y

# Verify that Docker isn't already installed through apt
apt-get remove docker docker-engine docker.io containerd runc

# Install other needs packages & tools for installation
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \

# Add Docker's official GPG key
mkdir -p /etc/apt/keyrings -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker engine
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Check to make sure that Docker is running
SERVICE_NAME="docker.service"

if ! systemctl is-active --quiet "$SERVICE_NAME"; then
  systemctl start "$SERVICE_NAME"
  echo "Started $SERVICE_NAME"
else
  echo "$SERVICE_NAME is already running"
fi