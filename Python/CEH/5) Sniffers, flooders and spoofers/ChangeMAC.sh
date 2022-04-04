# On Kali Linux
sudo apt-get install macchanger
macchanger --help

# Show current
macchanger -s eth0

# Change random
macchanger -r eth0

# Change MAC to specified
macchanger -m eth0 XX:XX:XX:XX:XX:XX

# OR

ifconfig eth0 down
ifconfig eth0 hw ether XX:XX:XX:XX:XX:XX
ifconfig eth0 up