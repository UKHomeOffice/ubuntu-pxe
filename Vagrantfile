box = "ubuntu14.04"
url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
hostname = "iso-builder" 
domain = "builder.com" 
ip_address = "192.168.87.254"
ram = 2048

# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = box 
  config.vm.box_url = url
  config.vm.hostname = hostname + '.' + domain
  #config.vm.network "private_network", ip: ip_address 
  config.vm.network "public_network", ip: ip_address 

  config.vm.provider "virtualbox" do |vb|
    vb.customize [
      'modifyvm', :id,
      '--memory', ram
    ]
  end

end
