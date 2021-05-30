# Use head and tail to display the fifth line of the file /etc/passwd
head -n 5 /etc/passwd | tail -n 1

# Use sed to display the fifth line of the file /etc/passwd
sed -n 5p /etc/passwd

# Use awk in a pipe to filter the first column out of the results of the command ps aux
ps aux | awk -F : '{ print $1 }'

# Use grep to show the names of all files in /etc that have lines starting with the text 'root'
grep -l '^root' /etc/* 2>/dev/null

# Use grep to show all lines from all files in /etc that contain exactly 3 characters
grep '^...$' /etc/* 2>/dev/null

# Use grep to find all files that contain the string "alex", but make sure "alexander" is not included in the search result
grep '\<alex\>' /etc/* 2>/dev/null
