# See system info
uname

# See logged in user activity
last

# Clear screen
Ctrl + L

# Search man pages for appropriate util (-k = keyword)
man -k user
man -k user | wc
man -k user | grep 8 | create

# Fix man pages -k if nothing appropriate error message
su -
mandb

# Use less to read text files
less sag.txt

# View allowed sudo commands
sudo -l

# Change GUI to virtual terminal
chvt 2 # 6 Virtual Terminals. Only 1 is graphical

who
whoami
who am i

scp /etc/hosts 192.168.22.99:/var/tmp
scp 192.168.22.99:/etc/hosts .