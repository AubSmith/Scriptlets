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
    full_url = url + "/" + word
    response = request(full_url)
    if response:
        print("Dicovered at this line: " + full_url)
