# Invoke the script as follows:
# python .\artifactoryCreateToken.py "username" "group" "true" "31556952" "jfrt@*"

# Import the required modules
import configparser, json, requests, sys

# Assign variables based on input parameters
username    = sys.argv[1]
scope       = sys.argv[2]
refreshable = sys.argv[3]
expires     = sys.argv[4]
audience    = sys.argv[5]


# Build the JSON construct
jsonToken = { "key": username, "rclass" : scope, "packageType": refreshable, "description": expires, "audience": audience }


# Read the environment settings from Artifactory.ini
config = configparser.ConfigParser() 
config.readfp(open(r'.\Config\A:Artifactory.ini'))

# Load Artifactory environment and build URL
artifactory = config.get('Environment', 'Test')
apiv1 = "api/security/token" # Change this API URL to any API method as required


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