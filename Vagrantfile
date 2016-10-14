# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

SUBNET="192.168.128"
DOMAIN="vm.local"

MASTERNAME="puppetmaster"
MASTERIP="#{SUBNET}.2"

DBNAME="puppetdb"
DBIP="#{SUBNET}.3"

REPORTSNAME="puppetreports"
REPORTSIP="#{SUBNET}.4"

MASTERNAME="puppetmaster2"
MASTERIP="#{SUBNET}.5"

AGENTS=["websrv"]


#Generate a host file to share
$hostfiledata="127.0.0.1 localhost\n#{MASTERIP} #{MASTERNAME}.#{DOMAIN} #{MASTERNAME}"
$hostfiledata=$hostfiledata+"\n#{DBIP} #{DBNAME}.#{DOMAIN} #{DBNAME}"
$hostfiledata=$hostfiledata+"\n#{REPORTSIP} #{REPORTSNAME}.#{DOMAIN} #{REPORTSNAME}"
AGENTS.each_with_index do |agent,index|
  $hostfiledata=$hostfiledata+"\n#{SUBNET}.#{index+10} #{agent}.#{DOMAIN} #{agent}"
end

$set_host_file="cat <<EOF > /etc/hosts\n"+$hostfiledata+"\nEOF\n"

Vagrant.configure VAGRANTFILE_API_VERSION do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end
  
#  if Vagrant.has_plugin?("vagrant-cachier")
#    config.cache.scope = :box
#    config.cache.synced_folder_opts = {
#      owner: "_apt",
#      group: "_apt"
#    }
#  end

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  # workaround because of this Vagrant 1.8.5 issue (only on rhel-like distribs) => https://github.com/mitchellh/vagrant/issues/7610
  config.ssh.insert_key = false
  config.vm.define :puppetmaster do |pm|
    pm.vm.box = "boxcutter/centos72"
    pm.vm.hostname = "#{MASTERNAME}.#{DOMAIN}"
    pm.vm.network :private_network, ip: "#{MASTERIP}" 
    pm.vm.network :forwarded_port, guest: 5000, host: 5000
    pm.vm.provision :shell, :inline => $set_host_file
    pm.vm.provision :shell, :path => "bootstrap_centos.sh"
	
  config.vm.define :puppetmaster2 do |pm|
    pm.vm.box = "boxcutter/centos72"
    pm.vm.hostname = "#{MASTERNAME}.#{DOMAIN}"
    pm.vm.network :private_network, ip: "#{MASTERIP}" 
    pm.vm.network :forwarded_port, guest: 5000, host: 5000
    pm.vm.provision :shell, :inline => $set_host_file
    pm.vm.provision :shell, :path => "bootstrap_centos.sh"	

    
#    pm.vm.provider "virtualbox" do |v|
#      v.memory=2048
#      v.cpus=2
#    end
  end

  config.vm.define :puppetdb do |pm|
    pm.vm.box = "boxcutter/centos72"
    pm.vm.hostname = "#{DBNAME}.#{DOMAIN}"
    pm.vm.network :private_network, ip: "#{DBIP}" 
    pm.vm.provision :shell, :inline => $set_host_file
    pm.vm.provision :shell, :path => "install_agent_centos.sh"
  end

  config.vm.define :puppetreports do |pm|
    pm.vm.box = "boxcutter/centos72"
    pm.vm.hostname = "#{REPORTSNAME}.#{DOMAIN}"
    pm.vm.network :private_network, ip: "#{REPORTSIP}" 
    pm.vm.network :forwarded_port, guest: 5000, host: 5001
    pm.vm.provision :shell, :inline => $set_host_file
    pm.vm.provision :shell, :path => "install_agent_centos.sh"
  end

  AGENTS.each_with_index do |agent,index|
    config.vm.define "#{agent}".to_sym do |ag|
        ag.vm.box = "boxcutter/centos72"
        ag.vm.hostname = "#{agent}.#{DOMAIN}"
        ag.vm.network :private_network, ip: "#{SUBNET}.#{index+10}"
        ag.vm.provision :shell, :inline => $set_host_file
        ag.vm.provision :shell, :path => "install_agent_centos.sh"
    end
  end  

end
