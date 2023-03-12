#!/bin/bash

# mySQL vars
MYSQL_IP="10.0.0.19"
MYSQL_USER="k3sqluser"
MYSQL_PASSWORD="HappySlappy123!"
MYSQL_DB="k3s"

#k3s vars
K3S_VERSION="v1.24.10+k3s1"
IP_NODE_1="10.0.0.16"
IP_NODE_2="10.0.0.17"
IP_NODE_3="10.0.0.18"
K3S_TOKEN="$IP_NODE_1:/var/lib/rancher/k3s/server/node-token"

# NginX vars
NGINX_SERVER_IP="10.0.0.15"
NGINX_SERVER_DNS="rancher.zetechnical.com"