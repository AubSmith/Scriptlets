#!/usr/bin/python

# Import libraries
import crypt

word = "admin"
cryptWord = crypt.crypt(word, 'salt')
print(cryptWord)

word2 = "basketball"
cryptWord2 = crypt.crypt(word2, 'GH')
print(cryptWord2)

# Create pass.txt with these values
# admin:$cryptWord2
# root:$cryptWord1

# Create dictionary.txt
# admin
# word
# Text
# basketball