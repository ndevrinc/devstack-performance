#!/bin/bash
set -e

if [ ! -f /etc/sitespeed_provisioned_at ]
  then
  # Add Google public key to apt, needed to get Chrome
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

  # Add Google to the apt-get source list, needed to get Chrome
  sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

  # Update
  apt-get update

  # Install git, curl, java, firefox, chrome, unzip, xvfb
  apt-get -y install git curl default-jre-headless firefox google-chrome-stable unzip xvfb

  # Extras for xvfb
  apt-get install -y libgl1-mesa-dri xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

  # Get node and npm
  apt-get install -y nodejs npm

  # Setup node (is there a better way to do this?)
  if [ ! -f /usr/local/bin/node ]
    then
    ln -s /usr/bin/nodejs /usr/local/bin/node
  fi

  # install sitespeed.io
  npm install -g sitespeed.io

  # Now fetch the chrome driver
  wget -N http://chromedriver.storage.googleapis.com/2.13/chromedriver_linux64.zip
  unzip chromedriver_linux64.zip
  rm chromedriver_linux64.zip
  chmod +x chromedriver
  mv -f chromedriver  /usr/bin/chromedriver

  # Set locale
  echo "export LC_ALL='en_US.utf8'" >> ~/.bashrc

  # Turn off chrome auto update
  if [ -f /etc/apt/sources.list.d/google-chrome.list ]
    then
    mv /etc/apt/sources.list.d/google-chrome.list /etc/apt/sources.list.d/google-chrome.list.save
  fi

  # Install Selenium
  npm install selenium-standalone@latest -g
  selenium-standalone install
  cp /home/vagrant/provisioning-files/selenium-start.sh /bin/
  cd /bin
  wget https://selenium-release.storage.googleapis.com/2.46/selenium-server-standalone-2.46.0.jar
  chmod +x /bin/selenium-start.sh
  /bin/selenium-start.sh
  cp /home/vagrant/provisioning-files/selenium.conf /etc/init/

  echo 'Installation finished'

  date > /etc/sitespeed_provisioned_at
fi
exit