# Display inode number
ls -il /etc/hosts

ln /etc/hosts ~/hosts
ls -il /etc/hosts ~/hosts

vi /etc/hosts # 10.0.0.10 localhost

ls -il /etc/hosts ~/hosts

ln -s /etc/hosts ~/symhosts
ls -il /etc/hosts ~/hosts ~/symhosts
rm -f /etc/hosts

ls -il /etc/hosts ~/hosts ~/symhosts

cat ~/symhosts
ln ~/hosts /etc/hosts

ls -il /etc/hosts ~/hosts ~/symhosts

ls -l