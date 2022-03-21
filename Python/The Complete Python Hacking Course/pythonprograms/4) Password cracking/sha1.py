#!/usr/bin/python

from urllib.request import urlopen
from termcolor import colored
import hashlib

sha1hash = input("[*] Enter SHA1 hash value: ")

passlist = str(urlopen('https://raw.githubusercontent.com/AubSmith/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-10000.txt').read(), 'utf-8')

for i in passlist.split('\n'):
    hashguess = hashlib.sha1(bytes(i, 'utf-8')).hexdigest()
    if hashguess == sha1hash:
        print(colored("[+] The password is: " + str(i), 'green'))
        quit()
    else:
        print(colored("[-] Password guess " + str(i) + " does not match, trying next...", 'red'))

print("Password not in password list")
