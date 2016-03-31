#!/bin/bash

# Run on VM to bootstrap Puppet Master server

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " "
echo "Bootstraping..."
echo " "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

# Configure /etc/hosts file
echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
echo "192.168.32.5  foreman.domain  foreman" | sudo tee --append /etc/hosts 2> /dev/null && \
echo "192.168.32.6  foreman-enc.domain  foreman-enc" | sudo tee --append /etc/hosts 2> /dev/null && \
echo "192.168.32.7  foreman-reports.domain  foreman-reports" | sudo tee --append /etc/hosts 2> /dev/null && \
echo "192.168.32.8  db.domain  db" | sudo tee --append /etc/hosts 2> /dev/null && \
echo "192.168.32.10 puppetmaster-1.domain  puppetmaster-1" | sudo tee --append /etc/hosts 2> /dev/null
echo "192.168.32.12 puppet-ca.domain  puppet-ca" | sudo tee --append /etc/hosts 2> /dev/null

# global 
# apps and packages
sudo apt-get update -y && \
sudo apt-get install -y gcc && \
sudo apt-get install -y nano && \
sudo apt-get install -y screen && \
sudo apt-get install -y git && \
sudo apt-get install -y ntp && \
sudo apt-get install -y wget && \
sudo apt-get install -y curl && \
sudo apt-get install -y traceroute && \
sudo apt-get install -y hdparm && \
sudo apt-get install -y lvm2 && \
sudo apt-get install -y tree && \

#performance
sudo apt-get install -y iotop && \
sudo apt-get install -y lsof && \
sudo apt-get install -y htop && \

sudo apt-get -y autoremove  && \

# puppet package
sudo apt-get update -y && \
sudo apt-get -y install ca-certificates && \
sudo wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb && \
sudo dpkg -i puppetlabs-release-precise.deb && \
sudo apt-get update -y && sudo apt-get install puppet -y && \

sudo apt-get -y autoremove  && \

# foreman package
sudo apt-get update -y && \
sudo echo "deb http://deb.theforeman.org/ precise 1.10" > /etc/apt/sources.list.d/foreman.list && \
sudo echo "deb http://deb.theforeman.org/ plugins 1.10" >> /etc/apt/sources.list.d/foreman.list && \
sudo wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add - && \
sudo apt-get -y update && \
sudo apt-get -y install foreman-installer && \
# sudo apt-get -y install foreman-libvirt && \
# sudo apt-get -y install foreman-console && \
# sudo apt-get -y install foreman-mysql2 && \
# sudo apt-get -y install foreman-sqlite3 && \

sudo apt-get -y autoremove  && \

# certs
sudo mkdir -p -v /etc/ssl/domain/certs/ && \
sudo mkdir -p -v /etc/ssl/domain/private_keys/ && \

# ln -s /vagrant/SSL/domain/certs/ca.pem /etc/ssl/domain/certs/ca.pem && \
# ln -s /vagrant/SSL/domain/certs/domain.pem /etc/ssl/domain/certs/domain.pem && \
# ln -s /vagrant/SSL/domain/private_keys/domain.pem /etc/ssl/domain/private_keys/domain.pem 

sudo cp /vagrant/SSL/domain/certs/ca.pem /etc/ssl/domain/certs/ca.pem && \
sudo cp /vagrant/SSL/domain/certs/intermediate.crl.pem /etc/ssl/domain/certs/intermediate.crl.pem && \
sudo cp /vagrant/SSL/domain/certs/domain.pem /etc/ssl/domain/certs/domain.pem && \
sudo cp /vagrant/SSL/domain/private_keys/domain.pem /etc/ssl/domain/private_keys/domain.pem 

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "End Bootstraping..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
