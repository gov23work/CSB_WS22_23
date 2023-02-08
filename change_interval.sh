#!/bin/bash
sudo sed -i "3s/.*/  scrape_interval: ${1}s/" /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus
