import requests, json, sys

#enter credentials
username = "update username"
password = "update password"

# Assign variables based on input parameters
bundleName = sys.argv[1] # String
version    = sys.argv[2] # String
dry_run    = sys.argv[3] # Boolean
#description = sys.argv[4]

# Build the JSON construct
jsonbdl = {'dry_run': dry_run,
           'distribution_rules': '' }

appurl = 'https://url/' # URL
# api = "api/trash/empty" #you can change this API URL to any API method you'd like to use, this URL will empty the trash can
api = '/api/v1/keys/distribution/'
url = appurl + api + bundleName + '/' + version

r = requests.post(url, data=json.dumps(jsonbdl), auth = (username, password), verify=False)

print(url)

if r.status_code == 200:
  print(r.content)
else:
  print('Fail')
  response = json.loads(r.content)
  print(response)
