# Delete history
history -d 500 510 # Delete row 500 thru 510 from history
history -c # Clear all history

# Check current user
id -a
whoami

# su Switch User
su # Elevates user context to root
pwd
su - # Switches context to root - recommended
pwd
su - amy
exit
exit

# sudo (Super User Do)
# Only option on Ubuntu - no root password

sudo useradd newuser
sudo passwd newuser # Set password
usermod -aG groupname newuser # Add user to group
grep newuser /etc/passwd
su - newuser
sudo passwd root

# CentOS wheel = admin group
# Ubuntu admin = admin group

sudo -i # Open root shell

sudo visudo # Update sudo file

cd /etc/sudoers.d/ # Create snap-in files
