import requests
import json

#enter credentials
# username = "update username"
# password = "update password"

# Build the JSON construct
#jsongpgv2 = { 'key': {'public_key': public_key ,
#            'private_key': private_key },
#            'propagate_to_edge_nodes': true, 'fail_on_propagation_failure': false }

jsongpg = {'public_key': '''''',
           'private_key': '''''' }

appurl = 'https://url/' # URL
# api = "api/trash/empty" #you can change this API URL to any API method you'd like to use, this URL will empty the trash can
api = '/api/v1/keys/pgp'
url = appurl + api

r = requests.put(url, auth = (username, password), verify=False)

print(url)

if r.status_code == 200:
  print(r.content)
else:
  print('Fail')
  response = json.loads(r.content)
  print(response)

  print( 'x-request-id : ' + r.headers['x-request-id'] )
  print( 'Status Code : ' + r.status_code)
