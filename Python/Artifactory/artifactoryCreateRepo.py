# Invoke the script as follows:
# python .\artifactoryCreateRepo.py "pypi" "aubs" "local" "This is my demo repo"

# Import the required modules
import configparser, json, requests, sys

# Assign variables based on input parameters
packageType = sys.argv[1]
repoName    = sys.argv[2]
repoType    = sys.argv[3]
description = sys.argv[4]


# Build the JSON construct
jsonrepo = { "key": repoName, "rclass" : repoType, "packageType": packageType, "description": description }


# Read the environment settings from Artifactory.ini
config = configparser.ConfigParser() 
config.readfp(open(r'.\Config\A:Artifactory.ini'))

# Load Artifactory environment and build URL
artifactory = config.get('Environment', 'Test')
apiv1 = "api/security/users/admin" #you can change this API URL to any API method you'd like to use


# Load credentials
username = config.get('User', 'UserName')
apikey = config.get('Token', 'Token')


url = artifactory + apiv1

headers = {'Authorization': 'Bearer ' + apikey, "Content-Type": "application/json"}

# response = requests.put(url, auth = (username, apikey), verify=False) # ONLY USE IN PRE-PRODUCTION
response = requests.put(url, data=json.dumps(jsonrepo), headers=headers, verify=False) # ONLY USE IN PRE-PRODUCTION

print(response.content)


if response.status_code == 200:
  print(response.content)
else:
  print("Fail")
  response = json.loads(response.content)
  print(response["errors"])

  print( "x-request-id : " + response.headers['x-request-id'] )
  print( "Status Code : " + response.status_code)