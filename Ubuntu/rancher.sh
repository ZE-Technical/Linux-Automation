#!/bin/bash

# Check if Docker is installed
if ! command -v docker > /dev/null 2>&1; then
  echo "Docker is not installed. Please install Docker and try again."
  exit 1
fi

# Start the Rancher server
sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:stable

# Verify the Rancher server is up and running
curl http://localhost