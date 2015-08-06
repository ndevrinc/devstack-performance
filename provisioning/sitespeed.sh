#!/bin/bash
set -e

if [ ! -d /etc/sitespeed_provisioned_at ]
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

  # echo some info on login
  echo "sitespeed.io --version" >> ~/.bashrc
  echo "chromedriver --version" >> ~/.bashrc
  echo "google-chrome-stable --version" >> ~/.bashrc
  # Starting Firefox will get us this message
  # GLib-CRITICAL **: g_slice_set_config: assertion 'sys_page_size == 0' failed
  # https://bugzilla.mozilla.org/show_bug.cgi?id=833117
  # echo "firefox -version"

  # and then turn off chrome auto update
  mv /etc/apt/sources.list.d/google-chrome.list /etc/apt/sources.list.d/google-chrome.list.save

  echo 'Installation finished'

  date > /etc/sitespeed_provisioned_at
fi
exit