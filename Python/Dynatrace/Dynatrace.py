#!/usr/bin/env python

# Invoke the script as follows:
# python .\Dynatrace.py

# Import the required modules
import configparser, json, requests, sys

# Assign variables based on input parameters
value = sys.argv[1]
description = sys.argv[2]
var3 = sys.argv[3]
var4 = sys.argv[4]

# Read the environment settings from Dynatrace.ini
config = configparser.ConfigParser() 
config.readfp(open(r'.\Config\A:Dynatrace.ini'))
# config.readfp(open(r'D:\Dynatrace\API\Python\Dynatrace.ini'))
# config.read_file(r'D:\Dynatrace\API\Python\Dynatrace.ini')

# Build the JSON construct
jsonrepo = { "key": value, "description": description }

# Load credentials
username = config.get('User', 'UserName')
apikey = config.get('Token', 'Token')

# Load Dynatrace environment and build URL
Dynatrace = config.get('Environment', 'Test')
apiv1 = "api/security/users/admin" #you can change this API URL to any API method you'd like to use

url = Dynatrace + apiv1

headers = {'Authorization': 'Bearer ' + apikey, "Content-Type": "application/json"}

# response = requests.put(url, auth = (username, apikey), verify=False) # ONLY USE IN PRE-PRODUCTION
response = requests.put(url, data=json.dumps(jsonrepo), headers=headers, verify=False) # ONLY USE IN PRE-PRODUCTION

# Write response to file
if response.status_code == 200:
  with open('Config.txt', 'w') as outfile:
    json.dump(response.content, outfile)
else:
  print("Fail")
  response = json.loads(response.content)
  print(response["errors"])

  print( "x-request-id : " + response.headers['x-request-id'] )
  print( "Status Code : " + response.status_code)

# pip install gitpython

from git import Repo

gitpath = r'/path/to/your/git/folder/.git'
commitmsg = 'comment from python script'

def git_push():
    try:
        repo = Repo(gitpath)
        repo.git.add(update=True)
        repo.index.commit(commitmsg)
        origin = repo.remote(name='origin')
        origin.push()
    except:
        print('Please see logs for any errors.')    

git_push()