# Request a list of all installed packages. In this list see if an FTP server has been installed
# Use the software manager to install nmap

Working

# Request a list of all installed packages. In this list see if an FTP server has been installed
yum list installed
yum list installed | grep ftp

# Use the software manager to install nmap
sudo yum install nmap