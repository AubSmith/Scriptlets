##### UBUNTU #####
# list is somewhat similar to dpkg-query --list in that it can display a list of packages satisfying certain criteria.
apt list --upgradable
sudo apt-get update

# update is used to download package information from all configured sources.
sudo apt update
# upgrade is used to install available upgrades of all packages currently installed on the system from the sources configured via sources.list(5).
sudo apt upgrade

sudo apt dist-upgrade 