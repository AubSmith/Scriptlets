# /etc/yum.repos.d
# YUM config
cd /etc/yum.conf

# YUM repo paths
ls -al /etc/yum.repos.d

# Post password change CNTLM
cntlm -H -u user@domain

# Update
yum update

yum install
yum search
yum remove

yum groups list
yum groups install
yum provides
yum history


yum repolist

yum search nmap
yum install nmap-frontend

yum list all
yum list all | wc
yum list installed | grep ftp
yum list installed
yum list installed nmap
yum remove nmap

yum update
yum search semanage
yum provides semanage

yum groups list
yum groups install "Compute Node"

yum history
yum history undo