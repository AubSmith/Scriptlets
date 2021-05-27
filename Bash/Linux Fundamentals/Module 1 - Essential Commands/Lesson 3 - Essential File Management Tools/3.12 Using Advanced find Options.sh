find / -type f -size +100M

find /etc -exec grep -l amy {} \; -exec cp {} /root/amy/ \; 2>/dev/null
ls /root/amy/

find /etc -name '*' -type f | xargs grep "127.0.0.1"