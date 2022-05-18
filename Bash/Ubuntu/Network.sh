sudo nano /etc/network/interfaces

# auto eth1
# iface eth1 inet static
# address 192.168.1.3
# netmask 255.255.255.0
# network 192.168.1.0
# broadcast 192.168.1.255
# gateway 192.168.1.1
# dns-nameservers 192.168.1.1

sudo ifup eth1
