#!/usr/bin/env python

# .\ArtifactoryAutoTest "oat" "Aubs" "Aubs repo test" "maven"
# python .\Artifactory.py

# Import the required modules
import configparser, json, requests, sys


# Assign variables based on input parameters
env = sys.argv[1]

config = configparser.ConfigParser() 
config.readfp(open(r'.\Config\Artifactory.ini'))


# Load credentials
username = config.get('User', 'UserName')
apikey = config.get('Token', 'Token')

# Load Artifactory environment and build URL
artifactory = config.get('Environment', 'Test')
apiv1 = "api/security/users/admin" #you can change this API URL to any API method you'd like to use
apiv2 = "api/v2/security/permissions/groups/"
groupname = input()

url = artifactory + apiv2 + groupname


r = requests.get(url, auth = (username, apikey), verify=False) # ONLY USE IN PRE-PRODUCTION

if r.status_code == 200:
  print(r.content)
else:
  print("Fail")
  response = json.loads(r.content)
  print(response["errors"])

  print( "x-request-id : " + r.headers['x-request-id'] )
  print( "Status Code : " + r.status_code)