#!/bin/bash

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
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'HappySlappy123!';

# Exit mySQL promt
exit

# Run the mysql security script
spawn sudo mysql_secure_installation

expect "Press y|Y for Yes, any other key for No:"
send "y\r"

expect "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:"
send "2\r"

expect "New password:"
send "HappySlappy123!"

expect "Re-enter new password:"
send "HappySlappy123!"

expect "Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) :"
send "y\r"

expect eof

# Re-secure root user
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;

# Create a new user 
CREATE USER 'mysqluser'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'HappySlappy123!';

# Grant new user global priviledge
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, INDEX, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'mysqluser'@'localhost' WITH GRANT OPTION;

# Free up memory that server cached
FLUSH PRIVILEGES;

# Exit mySQL prompt
exit

# Verify mySQL is running and run if isn't
service_name="<service_name>"

if ! systemctl is-active --quiet "$service_name"; then
  systemctl start "$service_name"
  echo "Started $service_name"
else
  echo "$service_name is already running"
fi
