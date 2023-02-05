#!/bin/bash

# Import environment variables
source k3s_vars.sh

# Install Nginx
sudo apt -y install nginx

# Verify that Nginx service is running
service_name="nginx.service"

if ! systemctl is-active --quiet "$service_name"; then
  systemctl start "$service_name"
  echo "Started $service_name"
else
  echo "$service_name is already running"
fi

# Update /etc/nginx/nginx.conf file with the IP addresses of K3 Nodes

vi /etc/nginx/nginx.conf

worker_processes 4;
worker_rlimit_nofile 40000;

events {
    worker_connections 8192;
}

stream {
    upstream rancher_servers_http {
        least_conn;
        server $IP_NODE_1:80 max_fails=3 fail_timeout=5s;
        server $IP_NODE_2:80 max_fails=3 fail_timeout=5s;
        server $IP_NODE_3:80 max_fails=3 fail_timeout=5s;
    }
    server {
        listen 80;
        proxy_pass rancher_servers_http;
    }

    upstream rancher_servers_https {
        least_conn;
        server $IP_NODE_1:443 max_fails=3 fail_timeout=5s;
        server $IP_NODE_2:443 max_fails=3 fail_timeout=5s;
        server $IP_NODE_3:443 max_fails=3 fail_timeout=5s;
    }
    server {
        listen     443;
        proxy_pass rancher_servers_https;
    }

}

# reload Nginx
nginx -s reload