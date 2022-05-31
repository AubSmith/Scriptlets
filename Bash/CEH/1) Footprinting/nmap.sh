man nmap

nmap -h

# Scan host
nmap 192.168.1.8

# Scan host verbose
nmap -v 192.168.1.8

nmap 192.168.1.8,10,12

nmap 192.168.1.8-12

nmap 192.168.1.*

nmap servername.waynecorp.com

nmap -iL ./nmap.txt

# OS Version identification
nmap -A 192.168.1.1-100
# OR
nmap -O 192.168.1.1-100

-sP

--reason

--iflist

# Ping
nmap -sn 192.168.1.10

# Fast scan
nmap -F 192.168.1.10
