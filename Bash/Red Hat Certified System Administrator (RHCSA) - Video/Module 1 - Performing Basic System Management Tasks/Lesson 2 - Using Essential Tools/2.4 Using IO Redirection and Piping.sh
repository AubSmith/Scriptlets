ls /etc
ls /etc > etcfiles
less etcfiles

who
who etcfiles
cat etcfiles
ls >> etcfiles
cat etcfiles

grep -R student /etc
grep -R student /etc 2> /dev/null

ls -l /etc | wc
ls -l /etc | wc | less
ls -l /etc | grep host