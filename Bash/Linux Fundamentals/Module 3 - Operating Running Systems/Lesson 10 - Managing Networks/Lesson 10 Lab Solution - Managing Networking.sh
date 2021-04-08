# Verify current network configuration
# Check that you can ping google.com
# Use ss to get a list of services currently offered by the server
# Use nmap to get a list of services currently offered by the server



# Working
# Verify current network configuration
ip a
ip route show
cat /etc/resolve.conf

# Check that you can ping google.com
ping microsoft.com
ping google.com

# Use ss to get a list of services currently offered by the server
ss -tuna
grep 22 /etc/services

# Use nmap to get a list of services currently offered by the server
sudo apt-get install nmap
nmap localhost
