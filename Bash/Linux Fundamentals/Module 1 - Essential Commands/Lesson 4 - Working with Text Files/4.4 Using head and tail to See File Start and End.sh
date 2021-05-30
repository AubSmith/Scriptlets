# Show first 10 lines - default
head /etc/passwd

# N first number of lines
head -n 5 /etc/passwd

# Show last 10 lines - default
tail /etc/passwd

# N last number of lines
tail -n 5 /etc/passwd

head -n 5 /etc/passwd | tail -n 1 /etc/passwd

# Freshen option
tail -f /var/log/messages 
tail -500f /var/log/messages