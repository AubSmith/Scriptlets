# Set IP Address
ip addr show
nmcli connection add con-name eth0 ifname eth0 type ethernet
nmcli con mod eth0 ipv4.addresses 192.168.1.250/24

# Set DNS
nmcli con mod eth0 ipv4.dns "192.160.1.100"

nmcli con up eth0 

# Rename Host
hostnamectl set-hostname rhelsvrsql001.waynecorp.com

shutdown -r now

# Domain Join
sudo subscription-manager register
sudo subscription-manager attach --auto

sudo dnf install realmd sssd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation authselect-compat

realm  discover waynecorp.com
realm join waynecorp.com -U Administrator

sudo realm list

sudo authselect select sssd
sudo authselect select sssd with-mkhomedir

cat /etc/sssd/sssd.conf 
# See sssd.conf

sudo systemctl restart sssd

systemctl status sssd

is asmith

realm permit user1@waynecorp.com
realm permit user2@waynecorp.com user3@waynecorp.com

ream permit -g sysadmins
realm permit -g 'Security Users'
realm permit 'Domain Users' 'admin users'

# Permit/deny all - do not use
# sudo realm permit --all
# sudo realm  deny --all

sudo vi /etc/sudoers.d/domain_admins
# user1@waynecorp.com     ALL=(ALL)   ALL
# user2@waynecorp.com     ALL=(ALL)   ALL
# %group1@waynecorp.com     ALL=(ALL)   ALL
# %security\ users@waynecorp.com       ALL=(ALL)       ALL
# %system\ super\ admins@waynecorp.com ALL=(ALL)       ALL


# Configure Disks


# Install SQL Server


# Configure SQL Server


