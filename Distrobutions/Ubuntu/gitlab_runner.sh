#!/bin/bash

# Install dependencies
sudo apt-get update
sudo apt-get install -y curl

# Download and install the GitLab runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# Start and enable the GitLab runner service
sudo systemctl start gitlab-runner
sudo systemctl enable gitlab-runner

# Register the runner with your GitLab instance
sudo gitlab-runner register

# Wait for registration to complete
echo "GitLab runner registered. Please check your GitLab instance to confirm."