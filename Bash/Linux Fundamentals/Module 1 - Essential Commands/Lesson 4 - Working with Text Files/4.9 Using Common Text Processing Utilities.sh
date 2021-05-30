cut # filter output from text file
cut -d : -f 1 /etc/passwd

sort # sort files. Often used in pipes
cut -d : -f 1 /etc/passwd | sort

tr # translates between upper/lower cases
echo hello | tr [:lower:] [:upper:]

awk # search for specific patterns
awk -F : '{ print $4 }' /etc/passwd | sort -n # numeric sort
awk -F : '/amy/ { print $4 }' /etc/passwd

sed # stream editor to batch-modify text files
sed -n 5p /etc/passwd
# replace all instances of how with HOW
sed -i s/how/HOW/g # interactive
# delete line 2
sed -i -e '2d' myfile # edit