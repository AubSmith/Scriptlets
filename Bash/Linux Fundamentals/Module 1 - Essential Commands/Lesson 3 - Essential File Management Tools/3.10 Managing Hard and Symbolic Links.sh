ln /etc/hosts hosts
ls -li /etc/hosts hosts

ln /etc/hosts newhost
ls -li /etc/hosts hosts newhost
echo hello >> hosts
ls -li /etc/hosts hosts newhost

ln /etc/hosts /boot/oops
ln /etc/ hello

ln -s newhost symlink
mv symlink /tmp
ls -ls /tmp/symlink # Use absolute path, nt relative path
rm -f /tmp/symlink

ls -li /etc/hosts hosts newhost
ln -s /etc/hosts symhosts
ls -li /etc/hosts hosts newhost symhosts
rm /etc/hosts
ls -li /etc/hosts hosts newhost
cat symhosts
ln hosts /etc/hosts
ls -li /etc/hosts hosts newhost


cd /
ls -l