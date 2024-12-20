# Find package
apt-cache search bluefish*

# Search installed
apt-cache policy gimp
apt-cache policy bluefish

apt-cache search chrome
apt-cache policy chrome

# Update all packages
sudo apt-get upgrade

# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Manually install
sudo dpkg -i package_file.deb
sudo dpkg -i ./google-chrome-stable.deb
# Update the list of products
sudo apt-get update
# Enable the "universe" repositories
sudo add-apt-repository universe
# Install PowerShell
sudo apt-get install -y powershell
# Start PowerShell
pwsh