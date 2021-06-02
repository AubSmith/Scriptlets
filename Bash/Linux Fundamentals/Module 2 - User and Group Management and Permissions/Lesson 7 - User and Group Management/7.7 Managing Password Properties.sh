useradd linda # Leave password blank
passwd --help
passwd -S linda # Status
passwd -u linda # Unlock
passwd -uf linda # Force unlock

tail /etc/shadow

su - username
su - linda
exit

passwd linda

echo password | passwd --stdin linda
chage linda # Change password aging
grep linda /etc/shadow