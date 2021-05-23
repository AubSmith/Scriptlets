# Globbing

# * Everything
# ? One character
# [a-c] Range
# [a-c]*
# ?[z-s]*
# *?[a-z] String ending with letter

ls a*
ls -d a*
ls *a

ls -d a?* # At least one character after a
ls -d a?s*
ls -d a[ln]*
ls -d a[a-k]*