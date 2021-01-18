# Set static IP
sudo ifconfig eth0 172.29.120.155 netmask 255.255.255.0

# Del static IP
ip addr del 1.1.1.2/32 dev eth2
ifconfig en1 delete 192.168.141.99

# Reset DHCP
sudo dhclient -r

ifdown eth0

ifup eth0

# View all IPs
hostname --all-ip-addresses