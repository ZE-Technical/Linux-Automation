#!/bin/bash

# Import environment variables
source k3s_vars.sh

# Update apt repository
sudo apt update

# Install mysql-server package
sudo apt -y install mysql-server

# Start mysql service using systemctl
sudo systemctl start mysql.service

# NOTE!!! Post July 2022 mysql-server installation will fail due to root account being locked. The following commands account for this.

# Open mySQL promt
sudo mysql

# Change the root user's auth method to one that uses a password
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY $MYSQL_PASSWORD;

# Exit mySQL promt
exit

# Run the mysql security script
spawn sudo mysql_secure_installation

expect "Press y|Y for Yes, any other key for No:"
send "y\r"

expect "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:"
send "2\r"

expect "((Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "New password:"
send $MYSQL_PASSWORD

expect "Re-enter new password:"
send $MYSQL_PASSWORD

expect "Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect eof

# Re-secure root user
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;

# Create a new user 
CREATE USER $MYSQL_USER@'%' IDENTIFIED WITH caching_sha2_password BY $MYSQL_PASSWORD;

# Grant new user global priviledge
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, INDEX, DELETE, SELECT, REFERENCES, RELOAD on *.* TO $MYSQL_USER@'%' WITH GRANT OPTION;

# Free up memory that server cached
FLUSH PRIVILEGES;

# Exit mySQL prompt
exit

# Make sure that mySQL server IP is listed in /etc/mysql/mysql.conf.d/mysqld.cnf so remote devices can access dbs
sed -i "s/bind-address            = 127.0.0.1/bind-address            = "$MYSQL_IP"/n" /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart mysql.service
systemctl restart mysql.service

# Verify mySQL is running and run if isn't
SERVICE_NAME="mysql.service"

if ! systemctl is-active --quiet "$SERVICE_NAME"; then
  systemctl start "$SERVICE_NAME"
  echo "Started $SERVICE_NAME"
else
  echo "$SERVICE_NAME is already running"
fi