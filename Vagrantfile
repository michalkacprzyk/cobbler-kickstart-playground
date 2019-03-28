# mk (c) 2019
# vi: set ft=ruby :

# Force locales on ssh connections
ENV["LC_ALL"] = "en_US.UTF-8"

# 2 - configuration file version, do not change
Vagrant.configure("2") do |config|

# Global provider settings
  config.vm.provider "virtualbox" do |vb|
     # VMs CPU
     vb.cpus = 1
     # VMs RAM
     vb.memory = "256"
     # Use linked clones to save time and disk space 
     vb.linked_clone = true
     # Workaround VirtualBox E1000 NIC bug
     vb.default_nic_type = "virtio"
  end

  config.vm.define "master" do |node|
      node.vm.box = "centos/7"
      node.vm.network "private_network", ip: "192.168.10.5"
      config.vm.provision :shell, path: "bootstrap.sh"
  end
end
