# Show all process | filter ssh
ps aux | grep ssh

man -k user | grep 8

grep amy /etc/*
grep amy /etc/* 2>/dev/null
# Case insensitive -i
grep -i word /var/tmp/myfile # Finds word and WORD

ps aux | grep ssh | grep -v grep # remove grep from results

grep -R root * # Recursive search
grep -R root * -l # Recursive search. Show only filename

grep -A3 amy /etc/passwd # Show three lines after amy
grep -B3 amy /etc/passwd # Show three lines before amy