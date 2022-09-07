grep "function" file.py
grep "function" file.py file2.py

grep -i "function" ./*

grep -n -i "function" ./*

# Find all items with name ending sh
ls | grep $sh

# Find items with name starting rs
ls | grep ^rs

find . -type f -iname "*.py" -exec grep -i -n "function" {} +
find . -type f isize -10k -iname "*.py" -exec grep -i -n "function" {} +
