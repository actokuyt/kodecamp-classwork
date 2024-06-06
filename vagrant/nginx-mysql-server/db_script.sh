#!/usr/bin/env bash

apt-get update
apt-get install -y mysql-server

mysql <<EOF
CREATE DATABASE my_database;
CREATE USER 'my_user'@'%' IDENTIFIED BY 'my_password';
GRANT ALL PRIVILEGES ON my_database.* TO 'my_user'@'%';
FLUSH PRIVILEGES;
EOF

sed -i "s/bind-address\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql