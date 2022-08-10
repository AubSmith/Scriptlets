# Static IP
sudo ifconfig eth0 172.21.235.195 netmask 255.255.240.0

# Copy/download VSCode package
curl -o vscode.deb -L http://go.microsoft.com/fwlink/?LinkID=760868

# Install VSCode
sudo apt install ./vscode.deb

# Install SSH Server
sudo apt-get install openssh-server
sudo systemctl start ssh.service
sudo systemctl enable ssh.service
systemctl status ssh.service

# SSH Public Key

# Check sources
cat /etc/apt/sources.list

# Kali update 
sudo apt update
sudo apt full-upgrade -y # Downloads and updates packages, also removes already installed packages if needed.
sudo apt autoremove # Clean up old packages

# Other update options
sudo apt upgrade # Downloads and updates packages without deleting anything previously installed on Kali Linux.

# Install Kali headers
apt install linux-headers-$(uname -r)

# SSH
ssh-copy-id -i ~/.ssh/id_rsa.pub esmith@192.168.1.2