# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
domain = "example.com"
disk_directory = "./images/"
disk_size = 50 * 1024
box = 'ubuntu_14.04'
disk_count = 2
sata = 'SATA Controller'
node_ip_1 = "192.168.33.42"
node_ip_2 = "192.168.33.43"
node_ip_3 = "192.168.33.44"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # deploy node-1
  config.vm.define "node-1" do |node1|
    node1.vm.box = box
    node1.vm.network :private_network, ip: node_ip_1
    node1.vm.host_name = "node-1"
    node1.vm.provider :virtualbox do |vb|
       vb.customize [
         "modifyvm", :id,
         "--memory", "1024",
         "--name", "node-1",
       ]
       (1..disk_count).each do |disk_id|
         file_to_disk = disk_directory+"node-1-"+"#{disk_id}.vdi"
         unless File.exist?(file_to_disk)
           vb.customize ["createhd", "--filename", file_to_disk, "--size", disk_size]
         end
         vb.customize ["storageattach", :id, "--storagectl", sata, "--port", "#{disk_id}", "--device", 0, "--type", "hdd", "--medium", file_to_disk]
       end
    end
    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = "puppet/modules"
      puppet.facter ={
       'node_ip1' => node_ip_1,
       'node_ip2' => node_ip_2,
       'node_ip3' => node_ip_3,
      }
    end
  end
  #deploy node-2
  config.vm.define "node-2" do |node2|
    node2.vm.box = box
    node2.vm.network :private_network, ip: node_ip_2
    node2.vm.host_name = "node-2"
    node2.vm.provider :virtualbox do |vb|
       vb.customize [
         "modifyvm", :id,
         "--memory", "1024",
         "--name", "node-2",
       ]
     (1..disk_count).each do |disk_id|
       file_to_disk = disk_directory+"node-2-"+"#{disk_id}.vdi"
       unless File.exist?(file_to_disk)
         vb.customize ["createhd", "--filename", file_to_disk, "--size", disk_size]
       end
       vb.customize ["storageattach", :id, "--storagectl", sata, "--port", "#{disk_id}", "--device", 0, "--type", "hdd", "--medium", file_to_disk]
     end
    end
    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = "puppet/modules"
      puppet.facter ={
       'node_ip1' => node_ip_1,
       'node_ip2' => node_ip_2,
       'node_ip3' => node_ip_3,
      }
    end
  end
  #deploy node-3
  config.vm.define "node-3" do |node3|
    node3.vm.box = box
    node3.vm.network :private_network, ip: node_ip_3
    node3.vm.host_name = "node-3"
    node3.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id,
      "--memory", "1024",
      "--name", "node-3",
    ]
    (1..disk_count).each do |disk_id|
       file_to_disk = disk_directory+"node-3-"+"#{disk_id}.vdi"
       unless File.exist?(file_to_disk)
         vb.customize ["createhd", "--filename", file_to_disk, "--size", disk_size]
       end
       vb.customize [
         "storageattach", :id,
         "--storagectl", sata,
         "--port", "#{disk_id}",
         "--device", 0,
         "--type", "hdd",
         "--medium", file_to_disk
       ]
     end
   end
   config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "puppet/manifests"
     puppet.manifest_file = "site.pp"
     puppet.module_path = "puppet/modules"
     puppet.facter ={
      'node_ip1' => node_ip_1,
      'node_ip2' => node_ip_2,
      'node_ip3' => node_ip_3,
     }
   end
  end
end
