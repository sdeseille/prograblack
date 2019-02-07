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


# Preparing environment for Prometheus Server

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

# 

# Install Grafana
sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_5.4.3_amd64.deb 