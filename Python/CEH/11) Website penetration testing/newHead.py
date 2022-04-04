#!/usr/bin/python

import requests

# Mask web client in header
newHead = {'User-Agent': 'Firefox'}

resp = requests.get('http://httpbin.org/headers', headers = newHead)

print(resp.url)
print(resp.text)
