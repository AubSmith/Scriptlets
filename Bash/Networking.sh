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

# Find IP
ip a

nmcli
nmcli g # Use nmcli c OR nmclie d instead
nmcli c # Connections
nmcli d # Devices
nmcli connection show --active
nmcli connection show
nmcli connection show Wired\ connection\ 1
nmcli device show
nmcli con add con-name XXXX type xxx ifname xxxx
nmcli connection show --active
nmcli con mod xxxx ipv4.addresses xxx.xxx.xxx.xxx/24
nmcli con mod xxxx ipv4.gateway xxx.xxx.xxx.xxx
nmcli con mod xxxx ipv4.dns xxx.xxx.xxx.xxx
nmcli con show
nmcli con delete xxxx
nmcli con up xxxx
nmcli con mod Wired\ connection\ 1 ipv4.addresses +xxx.xxx.xxx.xxx/24
nmcli con mod Wired\ connection\ 1 +ipv4.dns xxx.xxx.xxx.xxx
nmcli connection show Wired\ connection\ 1
ip a s xxxx
cat /etc/resolv.conf
nmcli con up xxxx

system restart NetworkManager

# IP Address
ip -4 a s eth0
ip addr | grep eth0

# Flush DNS cache
sudo rndc flash lan

sysctl net.ipv4.ip_local_port_range
sysctl net.ipv4.tcp_fin_timeout
# (61000 - 32768) / 60 = 470

# NetStat
# Ubuntu
sudo apt-get install net-tools

#RHEL
dnf install net-tools

# All
netstat --all | head -n 15

# Show only TCP ports, use the --all and --tcp options
netstat --all | head -n 15

# Show only UDP ports, use the --all and --udp options
netstat -au | head -n 5

# Show all listening TCP and UDP ports with process ID (PID) and numerical address
# Short version is -tulpn
sudo netstat --tcp --udp --listening --programs --numeric

sudo netstat -anlp | grep cups

# Test port
netstat -ane | grep "443" | grep "LISTEN"
ip a
telnet 192.168.1.1 443

# Name resolution
sudo yum install bind-utils

ping -c 3 serverA
ping -c 3 192.168.1.5

nslookup serverA
nslookup 192.168.1.5
nslookup -type=MX wayneent.com

dig serverA
dig -x 192.168.1.5
dig wayneent.com MX

host serverA
host 192.168.1.5
host -C wayneent.com
host -t mx wayneent.com
host -a wayneent.com

# TCP Dump
sudo tcpdump -c 10 # Cap 10 Pkts
sudo tcpdump -c 10 -A
sudo tcpdump -c 10 -i wlan0
sudo tcpdump -c 10 -XX -i wlan0 # Hex
sudo tcpdump -i wlan0 port 22

# Netstat
netstat -nr
netstat -i
netstat -ta
netstat -tan
