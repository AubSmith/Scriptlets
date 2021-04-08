# Show current network configuration
ip a
ip addr show

ip addr del dev eth0 xxx.xxx.xxx.0/24 # Delete IP address configuration
ip addr add dev eth0 xxx.xxx.xxx.0/24 # Assign IP address configuration

# Show routing configuration
ip route show

ip route del default via xxx.xxx.xxx.xxx # Delete default route
ip route add default via xxx.xxx.xxx.xxx # Add default route

# Show name resolution (DNS) configuration
cat /etc/resolve.conf

# Obtain IPv4 from DHCP
dhclient

# Do not use - Obsolete
ifconfig
