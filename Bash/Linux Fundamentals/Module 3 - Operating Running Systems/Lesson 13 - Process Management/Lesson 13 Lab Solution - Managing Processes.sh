 #From root shell start three background processes
#   dd if=/dev/zero of=/dev/null
# Use appropriate command to show they are running as expected
# Change process priority so that one of these jobs gets double CPU resources
# Monitor processes are running as expected
# Terminate all three processes 

sudo -
dd if=/dev/zero of=/dev/null &
dd if=/dev/zero of=/dev/null &
dd if=/dev/zero of=/dev/null &

ps aux | grep dd | grep -v grep

sudo renice -n -10 67

top

killall dd