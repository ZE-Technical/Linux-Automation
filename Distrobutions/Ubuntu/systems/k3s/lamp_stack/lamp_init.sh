#!/bin/bash

# Install Apache 
sudo apt install apache2

# update Firewall
sudo ufw app list

# Allow traffic in on port 80 by using the Apache profile
sudo ufw allow in "Apache"

# Install mySQL Community

# Install PHP
sudo apt install php libapache2-mod-php php-mysql
