find / -name "hosts"
find / -name "host"

find / -user amy
mkdir /root/amy; find / -user amy -exec cp {} /root/amy \;
ls /root/amy

find / -size +100M
find / -size +100M 2>/dev/null
