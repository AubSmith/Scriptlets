#!/bin/bash

echo "Positional Parameters"
echo '$0 = ' $0
echo '$1 = ' $1
echo '$2 = ' $2
echo '$3 = ' $3

# All parameters
echo {$@}
# All parameters from parameter 3 onwards
echo {$@:3}

# AND
echo -n "Enter some integer:"
read num

if [[ ( $num -lt 5 ) && ( $num%2 -eq 0 ) ]]; then
echo "Even and less than 5"
else
echo "Not satisfied above condition"
fi

# OR
echo -n "Enter any number:"
read n

if [[ ( $n -eq 10 || $n -eq 20 ) ]]
then
echo "YES"
else
echo "NO"
fi

# String slicing
Str="Hey! Welcome to Bash script tutorials"
subStr=${Str:0:20}
echo $subStr