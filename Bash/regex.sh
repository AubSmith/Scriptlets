# Use '' for regex as escaped by shell and not interpreted
# Used by specific tools - grep, vim, awk, sed
grep 'a*' a*

# ^ beginning of line
# $ end of line
# \< beginning of a word
# \> end of a word
# \A start of a file
# \Z end of a file
# {n} exact n times
# {n,} minimal n times
# {,n} n times max
# {n,o} between n and o times
# * zero or more times
# + one or more times
# ? zero or one time
# . is a wildcard charcter

###############
# touch /var/tmp/regfile
# cat regfile 
###############
#
# abc def ghi
# ghi def abc
# abbc
# aBc
# 123123123
# abbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbc
# ac
#
###############

grep ^abc regfile
grep '^abc' regfile
grep 'abc$' regfile
grep 'a.c' regfile

grep 'ab{2}c' regfile
egrep 'ab{2}c' regfile

egrep 'a[bB]c' regfile
egrep '(123)' regfile
egrep '(123){2}' regfile
egrep '(123){4}' regfile
egrep 'ab*c' regfile
egrep 'ab+c' regfile
egrep 'ab?c' regfile

man -k user | grep '1|8'
man -k user | egrep '1|8'

grep -l '^root' /etc/* 2>/dev/null
grep '\<alex\>' /etc/* 2>/dev/null
grep '^...$' /etc/* 2>/dev/null