Devstack Performance
====================

`devstack-performance` is a Vagrant provisioning script that sets up a full performance monitoring stack on your local environment.

Installation
------------
Here's the steps and results you'll immediately see. It's possible the instructions below become outdated as we continue to update the project. The most accurate documentation will always live on GitHub.

### 1) Install Vagrant
While this can generally be a very quick process, each local environment is different and the best docs are on the vagrant site: http://docs.vagrantup.com/v2/installation/.

### 2) Install Vagrant Host Manager
We use this simply because it adds entries for graphite, grafana and sitespeed to point to your VM's IP address automatically when you provision the VM.
https://github.com/smdahlen/vagrant-hostmanager

### 3) Clone Devstack Performance Repository
This contains everything needed to spin up an instance on your local machine, it currently requires 2 Gb of memory and takes about 7-10 minutes to provision the VM the first time.
```
    $ git clone https://github.com/ndevrinc/devstack-performance
    $ cd devstack-performance
    $ vagrant up
```

***And now you wait...*** Once the provisioning scripts complete fully it will begin to record metrics for http://www.sitespeed.io every 5 minutes. If you'd like feel free to edit the provision/files/sample_cron.sh file before you vagrant up, or simply edit it on the box afterwards. Assuming your hosts entries were updated properly you should be able to pull up these pages in a browser:

#### Sitespeed Results
<a href="http://sitespeed" rel="nofollow">http://sitespeed</a> (simply shows browse-able doc structure to display the sitespeed.io HTML files)
![Browse Sitespeed.io directories](https://ndevr.io/wp-content/uploads/2015/08/sitespeed-directory-browse-e1439302456917.png)

#### Graphite Results
<a href="http://graphite" rel="nofollow">http://graphite</a> (gives you access to your Graphite data)
![Sample Graphite Graph of Ndevr Performance Data](https://ndevr.io/wp-content/uploads/2015/08/graphite-sample-graph.png)

#### Graphana Results
<a href="http://grafana:3000" rel="nofollow">http://grafana:3000</a> (gives you access to your Grafana dashboard admin)
![Comparing Automattic, Acquia and Laravel sites](https://ndevr.io/wp-content/uploads/2015/08/graphana-opensource.png)
Comparing Automattic, Acquia and Laravel sites

![Our pages are quite a bit faster...](https://ndevr.io/wp-content/uploads/2015/08/graphana-ndevr.png)
Our pages are quite a bit faster...

### 4) Edit the sample_cron.sh
We've provided a few extra commented out lines in the script for use as examples, but here are the documented <a href="http://www.sitespeed.io/documentation/configuration/">sitespeed.io configuration</a> options. We use this file to point sitespeed.io to our local environments while sending the Graphite data to our hosted instance so we can share/compare our data better.
### 5) Oops
That's fine, that's why we are using Vagrant. If you find yourself making to mistakes to back out from simply destroy the VM and start again. You've likely made some customizations to the sample_cron.sh file, so keep those handy when you start over.
