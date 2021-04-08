ping --help
ping -f google.com # Ping flood
ping -f -s 4096 google.com # Ping flood with 4096KB packets

netstat -tulpen
ss -tuna | less # Socket Stats

yum install nmap
nmap xxx.xxx.xxx.xxx # Portscan
nmap localhost

# DNS Verification
dig google.com
