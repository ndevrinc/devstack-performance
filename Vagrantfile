# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


# PROJECT VARIABLES
project_name = "performance"
ip_address = "192.168.100.108"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  # Private networking, automatically adds entry to host's /etc/hosts
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.vm.define project_name do |node|
    node.vm.hostname = project_name
    node.vm.network :private_network, ip: ip_address
    node.hostmanager.aliases = %w(graphite sitespeed grafana)
  end
  config.vm.provision :hostmanager

  # Map this entire repo to /var/www/[project_name]/
  # Uses NFS so it modifies your /etc/exports
  config.vm.synced_folder "./provisioning/files", "/home/vagrant/provisioning-files/", type: "nfs"


  if defined? VagrantPlugins::HostsUpdater
    config.hostsupdater.aliases = domains_array
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # This allows the git commands to work using host server keys
  config.ssh.forward_agent = true

  # To avoid stdin/tty issues
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision "shell" do |s|
    s.path = "provisioning/sitespeed.sh"
    s.keep_color = true
  end
  config.vm.provision "shell" do |s|
    s.path = "provisioning/graphite.sh"
    s.keep_color = true
  end
  config.vm.provision "shell" do |s|
    s.path = "provisioning/grafana.sh"
    s.keep_color = true
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end
end
