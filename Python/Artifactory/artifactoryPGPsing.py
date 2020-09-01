import requests
import json

#enter credentials
username = "update username"
password = "update password"

# Set the key
pub_key = '''PGP Public Key'''

# Build the JSON construct
jsongpg = { 'alias': 'Distribution Key',
            'public_key': pub_key
            }

appurl = 'https://url/' # URL
# api = "api/trash/empty" #you can change this API URL to any API method you'd like to use, this URL will empty the trash can
api = '/api/security/keys/trusted'
url = appurl + api

r = requests.post(url, data=json.dumps(jsongpg), auth = (username, password), verify=False)

print(url)

if r.status_code == 200:
  print(r.content)
else:
  print('Fail')
  response = json.loads(r.content)
  print(response)
