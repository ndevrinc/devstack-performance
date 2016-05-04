#!/bin/bash
set -e

if [ ! -f /etc/graphana_provisioned_at ]
  then

  #Installing Graphana
  wget https://grafanarel.s3.amazonaws.com/builds/grafana_2.1.0_amd64.deb
  apt-get install -y adduser libfontconfig
  dpkg -i grafana_2.1.0_amd64.deb
  echo "deb https://packagecloud.io/grafana/stable/debian/ wheezy main" >> /etc/apt/sources.list
  curl https://packagecloud.io/gpg.key | apt-key add -
  apt-get update
  apt-get install grafana

  echo 'Graphana Installation finished'

  date > /etc/graphana_provisioned_at
fi
exit