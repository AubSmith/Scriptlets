import requests
import json

#enter credentials
username = "update username"
password = "update password"

# Set the keys
pub = '''PGP Public Key'''

priv = '''PGP Private Key'''

# Cleanup the strings
pubk = pub.replace(' ', '')
priv_key = priv.replace(' ', '')
pub_key = pubk.replace('\n', '')

# Build the JSON construct
jsongpg = {'public_key': pub_key,
           'private_key': priv_key }

appurl = 'https://url/' # URL
# api = "api/trash/empty" #you can change this API URL to any API method you'd like to use, this URL will empty the trash can
api = '/api/v1/keys/pgp'
url = appurl + api

r = requests.put(url, data=json.dumps(jsongpg), auth = (username, password), verify=False)

print(url)

if r.status_code == 200:
  print(r.content)
else:
  print('Fail')
  response = json.loads(r.content)
  print(response)
