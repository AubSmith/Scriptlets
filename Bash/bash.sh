# Shortcuts
# Ctrl-l Clear screen
# Ctrl-u Clear current command line
# Ctrl-a Move to beginning of line
# Ctrl-e Move to end of line
# Ctrl-c Break current process
# Ctrl-d Exit 

# StdIn <
sort < /etc/services
sort < /etc/services > somewhereelse
cat somewhereelse

# StdOut >
ls > ~/myfile
who >> ~/myfile
ls > ~/myfile # Overwrites myfile

# StdErr 2>
grep -R root /proc 2>/dev/null
grep -R root /etc &> ~/myfile # Redirect StdIn and StdErr


ps aux | grep http 
ps aux | tee psfile | grep ssh # tee write input of pipe to file and then send as input to new pipe


# History
cat ~/.bash_history
history -c # Clear current in-memory history
history -w # Write history
# Ctrl-R for reverse-i-search
# !nn repeat specific history line
!51 # Invoke 51st entry in history
touch /etc/hello
sudo !! # invoke last command

history
wc .bash_history

# Command Line Completion
apt install bash-completion
env
echo $di # Tab x2
ip # Tab x2


# Variables
echo $USER
echo $LANG
LANG=fr_FR.UTF-8
ls --help

COLOR=red
echo $COLOR
bash
echo $COLOR
exit
export COLOR=blue
bash
echo $COLOR

# Alias available in sub-shell
# Variable is not