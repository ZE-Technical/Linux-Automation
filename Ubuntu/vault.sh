#!/bin/bash

# Download and install Vault
wget https://releases.hashicorp.com/vault/1.5.3/vault_1.5.3_linux_amd64.zip
unzip vault_1.5.3_linux_amd64.zip
sudo mv vault /usr/local/bin/

# Create a configuration file
sudo bash -c "cat >/etc/vault.d/vault.hcl << EOL
storage "file" {
  path = "/vault/data"
}

listener "tcp" {
  address = "localhost:8200"
  tls_disable = 1
}
EOL"

# Create a vault data directory
sudo mkdir /vault/data
sudo chown -R vault:vault /vault/data

# Create a systemd service to run Vault as a daemon
sudo bash -c "cat >/etc/systemd/system/vault.service << EOL
[Unit]
Description=Vault

[Service]
User=vault
Group=vault
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL"

# Start and enable the Vault service
sudo systemctl start vault
sudo systemctl enable vault

# Verify that the Vault service is running
systemctl status vault