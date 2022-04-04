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

# Kali update 
sudo apt-get update

# Install Kali headers
apt install linux-headers-$(uname -r)