# Find LDAP servers
host -t srv _ldap._tcp.%DOMAIN_NAME%

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

# See current UID and GUID
id

useradd --help # (CentOS)
useradd -c "The boss" -G wheel -s /bin/bash Dave
adduser Dave # (Ubuntu)
groupadd tech # Create group named tech

w # Shows who is currently logged in
who # Similar to w but sumarised
getent passwd username
usermod username

tail /etc/passwd

id username
usermod -G wheel username
id username
usermod -G sales username # Replaces wheel
usermod -aG wheel username

userdel username
groupdel sales

# Group membership
id | egrep -o 'groups=.*' | sed 's/,/\n/g' | cut -d'(' -f2 | sed 's/)//'