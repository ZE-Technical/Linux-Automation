#!/bin/bash

# Download Terraform Binary from HashiCorp with wget
wget https://releases.hashicorp.com/terraform/1.3.9/terraform_1.3.9_linux_amd64.zip

# Unzip Terraform Binary
unzip terraform_1.3.9_linux_amd64.zip

# Check PATH variable
echo $PATH

# Add Terraform Binary to PATH
mv terraform /bin/
