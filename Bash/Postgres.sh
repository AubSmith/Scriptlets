# -u postgres will only look at processes owned by the user postgres
# -f will look at the pattern in the whole command line, not only the process name
# -a will display the whole command line instead of only the process number
# -- will allow a pattern that begins by -D
pgrep -u postgres -fa -- -D

systemctl list-unit-files | grep enabled | grep postgres