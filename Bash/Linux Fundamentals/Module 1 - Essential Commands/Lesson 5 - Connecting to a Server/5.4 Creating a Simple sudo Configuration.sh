sudo visudo # /etc/sudoers

# %wheel      ALL=(ALL)       ALL # Members wheel can connect from all hosts = run all commands as all users

# lori    ALL=/bind/passwd # Lori can reset passwords

sudo passwd lori
su - lori
sudo passwd root

exit

sudo -i

cd /etc/sudoers.d/ # Snap-in files
ls
