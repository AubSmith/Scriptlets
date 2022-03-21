#!/usr/bin/python

import ftplib

def anonLogin(hostname):
    try:
        ftp = ftplib.FTP(hostname)
        ftp.login('anonymous', 'password')
        print("[+] " + hostname + " FTP anonymous login succeeded.")
        ftp.quit()
        return True
    except Exception:
        print("[-] " + hostname + " FTP anonymous login failed.")


host = input("Enter FTP IP Address: ")
anonLogin(host)
