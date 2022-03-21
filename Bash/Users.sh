


# User defaults
useradd -D # Set user default
vim /etc/login.defs
vim /etc/default/useradd
ls -la /etc/skel/

useradd linda
grep username /etc/shadow
grep username /etc/passwd
tail /etc/shadow


# Password Properties
passwd
passwd --help
passwd -S username
echo password | passwd --stdin username
chage username


# User and Group Config Files
cat /etc/group
cat /etc/gshadow # Not longer utilised
cat /etc/passwd
cat /etc/shadow

vipw -s # Use instead of vi /etc/passwd
vigr # Edit groups

# Session Management
who
w
loginctl list-sessions
loginctl show session id
loginctl show-user username
loginctl terminate-session session-id

# systemd homed
