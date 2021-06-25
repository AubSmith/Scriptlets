which # Find binaries in $PATH
locate # updatedb
find

which useradd
echo $PATH

locate useradd
updatedb # Need scheduled cron job
locate useradd 

find / -name hosts
find / -type f -size +100M
find / -user student
find /etc -exec grep -l student {} \; 2>/dev/null
grep -l student /etc/* 2>/dev/null
find /etc -size +100c -exec grep -l student {} \;  -exec cp {} /tmp \; 2>/dev/null