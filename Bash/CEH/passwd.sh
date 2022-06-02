var1=$(cat /etc/passwd | awk 'FS = ":" {print $1}')
for i  in $var1; do echo "Username: " $i; done
