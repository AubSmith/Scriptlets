# cat - dumps file content to screen
# -A shows all non-printable characters
# -b number of line
# -n numbers lines, but not empty lines
# -s suppress repeated empty lines
cat myfile
cat -A myfile
cat -b myfile
cat -n myfile
cat -s myfile

# tac
# like cat, but in reversed order
tac myfile