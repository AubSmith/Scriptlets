import requests
requests.get('https://google.com')
print(response.status_code)

print (type(response.json()) )
print(response.json())