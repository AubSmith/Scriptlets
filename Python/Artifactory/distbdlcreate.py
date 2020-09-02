import requests, json, sys

#enter credentials
username = "update username"
password = "update password"

# Assign variables based on input parameters
bundleName = sys.argv[1] # String
version    = sys.argv[2] # String
dry_run    = sys.argv[3] # Boolean
sign_now   = sys.argv[4] # Boolean

# Build the JSON construct
jsonbdl = {'name': bundleName,
           'version': version,
           'dry_run': dry_run,
           'sign_immediately': sign_now,
           'description': 'Test',
           'release_notes': {
             'syntax': 'plain_text',
             'content': ''
           }, 
           'spec':{ 'queries': [
             {
               'aql': 'items.find({ \"repo\" : \"example-repo-local\" })',
               '{"repo": "reponame",'
               '"path": {{"$match':'python*"}},'
               '"name": ""}'
               '}'
               ').sort('
                        '{' 
                          '{"desc": ["created"]}'
                        '}' 
               ').limit(1)'
             }
           ]
           }}


appurl = 'https://url/' # URL
# api = "api/trash/empty" #you can change this API URL to any API method you'd like to use, this URL will empty the trash can
api = 'distribution/api/v1/release_bundle/'
url = appurl + api

r = requests.post(url, data=json.dumps(jsonbdl), auth = (username, password), verify=False)

print(url)

if r.status_code == 200:
  print(r.content)
else:
  print('Fail')
  response = json.loads(r.content)
  print(response)
