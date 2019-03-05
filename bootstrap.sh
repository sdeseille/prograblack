#!/usr/bin/env bash


#_______________________________________
#                                       #
# Downloading all installation packages #
#_______________________________________#

# Create Downloads directory in vagrant shared directory in order to store 
# all downloaded packages required to install
mkdir /vagrant/Downloads
cd /vagrant/Downloads

# Download Prometheus Server installation file
wget -q https://github.com/prometheus/prometheus/releases/download/v2.7.1/prometheus-2.7.1.linux-amd64.tar.gz

# Download Prometheus Node-Exporter installation file
wget -q https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz

# Download Prometheus Blakbox-Exporter installation file
wget -q https://github.com/prometheus/blackbox_exporter/releases/download/v0.13.0/blackbox_exporter-0.13.0.linux-amd64.tar.gz

# Download Grafana installation file
wget -q https://dl.grafana.com/oss/release/grafana_5.4.3_amd64.deb


#_____________________________________________
#                                             #
# Preparing environment for Prometheus Server #
#_____________________________________________#

# 1) we create user with no possibility to login
sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter
sudo useradd --no-create-home --shell /bin/false blackbox_exporter

# 2) we create folders to store binaries and config file of Prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# 3) we set ownership of these folders to prometheus account
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus


#_______________________
#                       #
# Installing Prometheus #
#_______________________#

# 1) we refresh our operating system before installing the product
sudo apt-get update && apt-get upgrade

# 2) we create a folder to unarchive prometheus server package
mkdir -p /home/vagrant/Prometheus/server
cd /home/vagrant/Prometheus/server
tar zxf /vagrant/Downloads/prometheus-*.tar.gz
cd /home/vagrant/Prometheus/server/prometheus-*

# 3) we get two binaries (prometheus, promtool) and two folders (consoles, console_libraries)
#    we have to copy these files in severals locations
sudo cp ./prometheus /usr/local/bin/
sudo cp ./promtool /usr/local/bin/

sudo cp -r ./consoles /etc/prometheus
sudo cp -r ./console_libraries /etc/prometheus

# 4) we set owner on binaries and directories
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

# 5) our last step is to clean home directory from unnecessary files
cd .. && rm -rf prometheus-*


#__________________________
#                          #
# Installing node_exporter #
#__________________________#

# 1) we create a folder to unarchive Node exporter package
mkdir -p /home/vagrant/Prometheus/node_exporter
cd /home/vagrant/Prometheus/node_exporter
tar zxf /vagrant/Downloads/node_exporter-*.tar.gz
cd /home/vagrant/Prometheus/node_exporter/node_exporter-*

# 2) we get a binary (node_exporter) to copy in /usr/local/bin
sudo cp node_exporter /usr/local/bin

# 3) we set ownership on copied binary in order to be able to use it
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# 4) and finally we remove unneeded files
cd .. && rm -rf node_exporter-*


#____________________
#                    #
# Installing Grafana #
#____________________#

cd /vagrant/Downloads/
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_5.4.3_amd64.deb 