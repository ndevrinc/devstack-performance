#!/bin/bash
set -e

if [ ! -f /etc/graphite_provisioned_at ]
  then

  # Install Python Dev Headers
  apt-get install -y python-dev

  # Download and install pip
  wget -N https://bootstrap.pypa.io/get-pip.py
  chmod +x get-pip.py
  python get-pip.py
  #clean up get-pip.py file
  rm get-pip.py

  # Install Django
  pip install django
  pip install django-tagging
  pip install pytz
  pip install pyparsing
  apt-get install -y libffi-dev
  pip install cairocffi

  # Install Selenium
  npm install selenium-standalone@latest -g
  selenium-standalone install
  xvfb-run --server-args="-screen 0, 1366x768x24" selenium-standalone start &

  # Install Graphite
  pip install https://github.com/graphite-project/ceres/tarball/master
  pip install whisper
  pip install https://github.com/graphite-project/carbon/tarball/master  --install-option="--prefix=/opt/graphite" --install-option="--install-lib=/opt/graphite/lib"
  pip install https://github.com/graphite-project/graphite-web/tarball/master --install-option="--prefix=/opt/graphite" --install-option="--install-lib=/opt/graphite/webapp"

  # Configure and start carbon
  pushd /opt/graphite/conf
  cp carbon.conf.example carbon.conf
  cp storage-schemas.conf.example storage-schemas.conf
  cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
  PYTHONPATH=/opt/graphite/webapp django-admin.py syncdb --noinput --settings=graphite.settings

  # Need to start carbon for graphite to be able to collect data
  /opt/graphite/bin/carbon-cache.py start

  #Install Apache
  apt-get install -y apache2 apache2-mpm-prefork apache2-utils libexpat1 ssl-cert
  cp /home/vagrant/provisioning-files/graphite.conf /etc/apache2/sites-available/
  ln -s /etc/apache2/sites-available/graphite.conf /etc/apache2/sites-enabled/graphite.conf
  cp /home/vagrant/provisioning-files/sitespeed.conf /etc/apache2/sites-available/
  ln -s /etc/apache2/sites-available/sitespeed.conf /etc/apache2/sites-enabled/sitespeed.conf

  chown -R www-data:www-data /opt/graphite/storage

  apt-get install -y libapache2-mod-wsgi

  # Create docroot directory for sitespeed.io generated files to be browseable
  mkdir /var/www/sitespeedio
  mkdir /var/www/sitespeedio/sitespeed-result
  chown -R www-data:www-data /var/www/sitespeedio

  # Add a sample bash script to run on cron
  cp /home/vagrant/provisioning-files/sample_cron.sh /home/vagrant/sample_cron.sh
  chmod +x /home/vagrant/sample_cron.sh
  chown vagrant:vagrant /home/vagrant/sample_cron.sh
  echo "*/5 * * * * www-data /home/vagrant/sample_cron.sh" >> /etc/crontab
  crontab /etc/crontab

  echo 'Graphite Installation finished'

  date > /etc/graphite_provisioned_at
fi
exit