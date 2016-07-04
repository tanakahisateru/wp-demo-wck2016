# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.1"
  config.vm.network "private_network", ip: "192.168.7.10"

  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
    ansible.install  = true
    # ansible.verbose  = true
  end
end
