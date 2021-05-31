# Standard input (0): <
sort < /etc/services
sort < /etc/services > myfile

# Standard output (1): >
ls > ~/myfile
cat ~/myfile

who >> ~/myfile
cat ~/myfile

# Standard error (2): 2>
grep -R root /proc 2>/dev/null
grep -R root /etc &>~/myfile

ps aux | grep http
ps aux | grep ssh
ps aux | tee psfile | grep ssh