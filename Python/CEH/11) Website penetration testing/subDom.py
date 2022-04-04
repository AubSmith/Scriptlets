#!/usr/bin/python

from urllib import response
import requests

url = input("Enter target URL: ")

def request(url):
    try:
        return requests.get("https://" + url)
    except requests.exceptions.ConnectionError:
        pass


dirFile = open("common.txt", 'r')
for line in dirFile:
    word = line.strip()
    full_url = word + "." + url
    response = request(full_url)
    if response:
        print("Sub-domain dicovered: " + full_url)
