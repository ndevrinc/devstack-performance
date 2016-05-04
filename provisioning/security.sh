#!/bin/bash
set -e

echo -n "Do you want to configure secure server (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then

  if [ ! -f /etc/security_provisioned_at ]
    then

    echo "Installing (ufw fail2ban unattended-upgrades)"
    apt-get install -y ufw fail2ban unattended-upgrades

    echo "Adjust APT update intervals"
    cp /home/vagrant/provisioning-files/apt_periodic /etc/apt/apt.conf.d/10periodic

    echo -n "What IP Address is safe? All others are blocked "
    read ip
    sudo ufw default deny
    sudo ufw allow from 127.0.0.1
    sudo ufw allow from $ip
    sudo ufw enable

    echo "Disable Password Authentication for SSH"
    sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    echo "Disallow root SSH access"
    sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo service ssh restart

    echo 'Security Installation finished'

    date > /etc/security_provisioned_at
  fi
fi
exit