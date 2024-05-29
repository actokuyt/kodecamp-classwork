#!/usr/bin/env bash

# update package lists
apt-get update

# install apache2 from apt(advance package tool)
apt-get install -y apache2

# sets up a redirect for apache2 from "/var/www" to "/vagrant"
# (essentially this tells apache2 to serve the files from /vagrant, which is the shared folder set up by vagrant between our host pc and the guest VM.)
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

