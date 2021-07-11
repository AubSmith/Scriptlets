# Release Bundle vi API

import requests, json, sys, configparser
 
 
# Assign variables based on input parameters
environent = sys.argv[1] # String
bundleName = sys.argv[2] # String
version    = sys.argv[3] # String
 
 
# Read the environment settings from Artifactory.ini
config = configparser.ConfigParser()
config.readfp(open(r'.\Distribution.ini'))
 
 
# Load credentials
username = config.get('User', 'UserName')
apikey = config.get('Token', 'Token')
 
 
# Build the JSON construct
jsonbdl = {'source_artifactory_id': 'jfrt@XXXXXXXXXXXXXXXXXXXXXXXXXX',
           'name': bundleName,
           'version': version,
           'sign_immediately': True,
           'description': 'Test',
           'spec':{ 'queries': [
             {
               'aql': 'items.find({ \"repo\" : \"generic-aubs-local\" })',
               '{"repo": "generic-aubs-local",'
               '"path": {{"$match':'vscode"}},'
               '"name": "VSCodeUserSetup-x64-1.44.2"}'
               '}'
             }
           ]
           }}
 
 
appurl = 'https://distribution.wayneent.com/' # URL
# api = "api/trash/empty" #you can change this API URL to any API method you'd like to use, this URL will empty the trash can
api = 'distribution/api/v1/release_bundle'
url = appurl + api
 
r = requests.post(url, data=json.dumps(jsonbdl), auth = (username, apikey), verify=False)
 
print(url)
 
if r.status_code == 201:
  print(r.content)
else:
  print('Fail')
  print(r.status_code)
  print(r.content)