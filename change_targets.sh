#!/bin/bash

targ="    - targets: [\"localhost:9090\", "
for var in "$@"
do
   targ="${targ}\"${var}:9100\", "
done
targ=${targ/%, /]}
echo "$targ"

sudo sed -i "29s/.*/${targ}/" /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus