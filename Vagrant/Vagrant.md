# Fast start

'''
vagrant init hashicorp/bionic64
# OR
vagrant init precise64 http://files.vagrantup.com/precise64.box

vagrant up

vagrant status

vagrant ssh

logout

vagrant destroy
vagrant destroy --force

# Use add instead of URL
vagrant box add

vagrant box list

# Pause - memory written to host disk
vagrant suspend

vagrant up

# Shutdown
vagrant halt
vagrant halt --force 

vagrant box remove

# Load changes to guest
vagrant reload

# Use specific provisioner
vagrant up --provision-with=chef
# Ignore provisioner
vagrant up --no-provision

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

# Multimachine
# Reload only web VM
vagrant reload web

vagrant status

vagrant status web

vagrant ssh web

# Reload multiple VMs named node
vagrant reload node1 node2 node3
vagrant reload /node\d/

# Debug
# Linux
VAGRANT_LOG=debug vagrant up

# Windows
set VAGRANT_LOG=debug
vagrant up
