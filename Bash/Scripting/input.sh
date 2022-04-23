#!/bin/bash

echo "Hello! Please provide a number:"
read number_1
echo "Please enter another number:"
read number_2

: '
Some comments may span
multiple lines
'
sum=$((number_1 + number_2))
diff=$((number_1 - number_2))

echo -e "You entered the following numbers: \n
$number_1
$number_2 \n
Sum = $sum
Differene = $diff"