# Kill
man 7 signal
ps aux | grep ssh
kill -9 PID# # Dirty
kill PID# # Same as 9 - tries clean kill
killall sshd

ps -efw | grep artifactory | awk '{print $2}' | xargs kill