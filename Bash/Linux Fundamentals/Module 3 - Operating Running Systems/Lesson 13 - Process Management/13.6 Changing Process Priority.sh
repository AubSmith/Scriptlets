# Change Process Priority
top
# Use r to renice priority

renice --help
ps aux | grep ssh
renice -n 10 PID#

nice -n 10 cmd