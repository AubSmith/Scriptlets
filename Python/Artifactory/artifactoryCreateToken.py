# Invoke the script as follows:
# python .\artifactoryCreateToken.py "username" "group" "true" "3600"

# Import the required modules
import configparser, json, requests, sys

# Assign variables based on input parameters
user        = sys.argv[1]
scope       = sys.argv[2]
refreshable = sys.argv[3]
expires     = sys.argv[4]


# Data
data = ('username={}'.format(user),
       'expires_in={}'.format(expires),
       'refreshable={}'.format(refreshable),
       'scope=member-of-groups:{}'.format(scope)
       )

print(data)

# Read the environment settings from Artifactory.ini
config = configparser.ConfigParser() 
config.readfp(open(r'.\Config\A:Artifactory.ini'))

# Load Artifactory environment and build URL
artifactory = config.get('Environment', 'Test')
api = "api/security/token" # Change this API URL to any API method as required


# Load credentials
username = config.get('User', 'UserName')
apikey = config.get('Token', 'Token')


url = artifactory + api

headers = {'Authorization': 'Bearer ' + apikey, "Content-Type": "application/json"}

# response = requests.put(url, auth = (username, apikey), verify=False) # ONLY USE IN PRE-PRODUCTION
response = requests.put(url, data=data, headers=headers, verify=False) # ONLY USE IN PRE-PRODUCTION

print(response.content)


if response.status_code == 200:
  print(response.content)
else:
  print("Fail")
  response = json.loads(response.content)
  print(response["errors"])

  print( "x-request-id : " + response.headers['x-request-id'] )
  print( "Status Code : " + response.status_code)