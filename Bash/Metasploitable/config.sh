vi /etc/network/interfaces

# auto eth0
# iface eth0 inet dhcp

# auto eth0
# iface eth0 inet static
# address 192.168.1.6
# netmask 255.255.255.0
# network 192.168.1.0
# broadcast 192.168.1..255
# gateway 192.168.1.1
# dns-nameservers 192.168.1.1

sudo /etc/init.d/networking restart