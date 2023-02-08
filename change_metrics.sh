#!/bin/bash
rm /var/lib/node_exporter/metrics*
div=10000
up=$1
count=1
if [ $1 -ge 10000 ]
then
  let count=$1/$div
  let up=10000
fi
for ((j=1;j<=$count;j++ ))
do
for ((i=1;i<=$up;i++ ))
  do
    echo "metric_lorem_ipsum_here$j{test=\"campus$i\"} $i" 
  done >> /var/lib/node_exporter/metrics${j}.prom
done