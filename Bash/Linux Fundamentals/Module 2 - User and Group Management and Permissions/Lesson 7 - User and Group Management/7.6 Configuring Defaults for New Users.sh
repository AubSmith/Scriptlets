useradd -D
vi /etc/login.defs
vi /etc/default/useradd
useradd --help
cd /etc/skel/ # Skeleton dir copied to all new user dirs

useradd linda
grep linda /etc/passwd
grep linda /etc/shadow
tail /etc/shadow

ls -l
cd linda
ls -la