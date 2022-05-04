# Fast start

'''
vagrant init hashicorp/bionic64

vagrant up

vagrant ssh

logout

vagrant destroy

vagrant box list

vagrant box remove hashicorp/bionic64
'''

# Build New Project

'''
mkdir vagrant_windows_server_2008
cd vagrant_windows_server_2008

vagrant up --provider hyperv
'''


# Vagrant file

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.box_url = "https://vagrantcloud.com/hashicorp/bionic64"
end

