#!/usr/bin/python

from termcolor import colored
import hashlib

def openWordlist(wordlist):
    global pass_file
    try:
        pass_file = open(wordlist, "r")
    except:
        print("[!!] No such file in path.")
        quit()



pass_hash = input("[*] Enter MD5 hash value: ")
wordlist = input("[*] Enter path to password file: ")
openWordlist(wordlist)

for word in pass_file:
    print(colored("[-] Trying: " + word.strip("\n"), 'red'))
    enc_wrd = word.encode('utf-8')
    md5digest = hashlib.md5(enc_wrd.strip()).hexdigest()

    if md5digest == pass_hash:
        print(colored("[+] Password found: " + word, 'green'))
        exit(0)

print("[!!] Password not in list.")
