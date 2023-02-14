export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt upgrade -y

#install curl
sudo apt install -y curl
#grab scripts from bucket
curl -X GET \
-H "Authorization: Bearer PASTE_TOKEN_HERE" \
-o "/tmp/change_metrics.sh" \
"https://storage.googleapis.com/storage/v1/b/scriptbucket_retrieval/o/change_metrics.sh?alt=media"

chmod +x /tmp/change_interval.sh
chmod +x /tmp/change_metrics.sh

#setup node exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz
cd node_exporter-1.5.0.linux-amd64
mkdir /var/lib/node_exporter
./node_exporter --collector.textfile.directory=/var/lib/node_exporter