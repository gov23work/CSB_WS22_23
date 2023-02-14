export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt upgrade -y
sudo apt install -y nginx
rm /etc/nginx/sites-enabled/default
service nginx restart
groupadd prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus
mkdir /var/lib/prometheus
for i in rules rules.d files_sd; do sudo mkdir -p /etc/prometheus/${i}; done
#install curl
sudo apt install -y curl

#get script to change targets and change interval
curl -X GET \
-H "Authorization: Bearer PASTE_TOKEN_HERE" \
-o "/tmp/change_interval.sh" \
"https://storage.googleapis.com/storage/v1/b/scriptbucket_retrieval/o/change_interval.sh?alt=media"
curl -X GET \
  -H "Authorization: Bearer PASTE_TOKEN_HERE" \
  -o "/tmp/change_targets.sh" \
  "https://storage.googleapis.com/storage/v1/b/scriptbucket_retrieval/o/change_targets.sh?alt=media"
chmod +x /tmp/change_targets.sh
chmod +x /tmp/change_interval.sh
#install node export on local machine as test 
#install prometheus on the machine
mkdir -p /tmp/prometheus
cd ../tmp/prometheus
wget "https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz"
tar xvf prometheus-2.41.0.linux-amd64.tar.gz
cd prometheus-2.41.0.linux-amd64/
mv prometheus /usr/local/bin/
mv promtool /usr/local/bin

#setup yml file for prometheus
mv prometheus.yml /etc/prometheus/prometheus.yml
mv consoles/ console_libraries/ /etc/prometheus/
mv prometheus.yml /etc/prometheus/prometheus.yml
mv consoles/ console_libraries/ /etc/prometheus/

#setup service
sudo tee /etc/systemd/system/prometheus.service<<EOF
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.external-url=

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
EOF
#change permissions to prom user
for i in rules rules.d files_sd; do sudo chown -R prometheus:prometheus /etc/prometheus/${i}; done
for i in rules rules.d files_sd; do sudo chmod -R 777 /etc/prometheus/${i}; done
chown -R prometheus:prometheus /var/lib/prometheus/

#restart systemd and restart prometheus
systemctl daemon-reload
systemctl unmask prometheus.service
systemctl enable prometheus
systemctl start prometheus

#setup firewall
ufw allow in "Nginx Full"
ufw allow 9090/tcp