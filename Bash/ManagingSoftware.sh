# RedHat supported repos
subscription-manager status
subscription-manager register
subscription-manager attach
subscription-manager repos --enable
subscription-manager repos --list 

ls -l /etc/yum.repos.d/*.repo

# yum config manager to manage repos

yum repolist all
yum info nmap
yum install -y nmap
yum update
yum update nmap
yum remove nmap

# Debian
sudo apt update && sudo apt upgrade