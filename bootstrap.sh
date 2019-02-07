#!/usr/bin/env bash


# Create Downloads directory in vagrant shared directory in order to store 
# all downloaded packages required to install
mkdir /vagrant/Downloads
cd /vagrant/Downloads

# Download Prometheus Server installation file
wget https://github.com/prometheus/prometheus/releases/download/v2.7.1/prometheus-2.7.1.linux-amd64.tar.gz

# Download Prometheus Node-Exporter installation file
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz

# Download Prometheus Blakbox-Exporter installation file
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.13.0/blackbox_exporter-0.13.0.linux-amd64.tar.gz

# Download Grafana installation file
wget https://dl.grafana.com/oss/release/grafana_5.4.3_amd64.deb
 
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

# 4) we set owner on directories
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

# 5) our last step is to clean home directory from unnecessary files
cd .. && rm -rf prometheus-*

# Install Grafana
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_5.4.3_amd64.deb 