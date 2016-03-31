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
sudo apt-get update -y && \
sudo apt-get install -y git && \
sudo apt-get install -y nano && \
sudo apt-get install -y wget && \
sudo apt-get install -y curl && \
sudo apt-get install -y htop && \
sudo apt-get -y autoremove  && \

# puppet
sudo apt-get update -y && \
sudo apt-get -y install ca-certificates && \
sudo wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb && \
sudo dpkg -i puppetlabs-release-precise.deb && \
sudo apt-get update -y && sudo apt-get install puppet -y && \
sudo apt-get -y autoremove  && \

# foreman
sudo apt-get update -y && \
sudo echo "deb http://deb.theforeman.org/ precise 1.10" > /etc/apt/sources.list.d/foreman.list && \
sudo echo "deb http://deb.theforeman.org/ plugins 1.10" >> /etc/apt/sources.list.d/foreman.list && \
sudo wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add - && \
sudo apt-get -y update && \
sudo apt-get -y install foreman-installer && \
sudo apt-get -y autoremove  && \

# mysql
sudo apt-get install -yq mysql-server && \
sudo service mysql restart && \
cp /etc/mysql/my.cnf /etc/mysql/my.cnf.old && \
sed -i 's/^bind-address.*/bind-address            = 192.168.32.8/' /etc/mysql/my.cnf && \
diff -c /etc/mysql/my.cnf /etc/mysql/my.cnf.old && \

sudo service mysql stop && \
sudo service mysql start && \


mysql -e "CREATE DATABASE foreman CHARACTER SET utf8;" && \
mysql -e "CREATE USER "foreman"@"foreman.domain";" && \
mysql -e "GRANT ALL PRIVILEGES ON foreman.* TO 'foreman'@'foreman.domain' IDENTIFIED BY 'foreman_password';" && \
mysql -e "CREATE USER 'foreman'@'foreman-enc.wit.prod';" && \
mysql -e "GRANT ALL PRIVILEGES ON foreman.* TO 'foreman'@'foreman-enc.domain' IDENTIFIED BY 'foreman_password';" && \
mysql -e "CREATE USER 'foreman'@'foreman-reports.wit.prod';" && \
mysql -e "GRANT ALL PRIVILEGES ON foreman.* TO 'foreman'@'foreman-reports.domain' IDENTIFIED BY 'foreman_password';" && \


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
