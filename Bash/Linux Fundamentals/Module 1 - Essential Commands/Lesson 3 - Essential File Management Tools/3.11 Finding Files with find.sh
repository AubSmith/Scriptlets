find / -name "hosts"
find / -name "host"

find / -user amy
mkdir /root/amy; find / -user amy -exec cp {} /root/amy \;
ls /root/amy

find / -size +100M
find / -size +100M 2>/dev/null

find . -type f -name "*.php"
find . -type f -iname "*.php" # Case insensitive
find . -type f -iname "file*"
find . -type f -not -iname "*.php" # Case insensitive
find /etc/ -maxdepth 1 -type f -iname "*.conf"

find . -type d -perm 0664
