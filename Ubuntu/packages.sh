#!/bin/bash

# Update apt repository
sudo apt-get update

# Upgrade all packages
sudo apt-get -y Upgrade

# Install needed packages
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip \
    wget \
    net-tools \
    stress \
