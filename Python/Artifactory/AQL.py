import configparser, json, requests

config = configparser.ConfigParser() 
config.readfp(open(r'.\App.ini'))
# config.read_file(r'.\App.ini')

# Load credentials
username = config.get('User', 'UserName')
apikey = config.get('Token', 'Token')

# Load  environment and build URL
app = config.get('Environment', 'Test')
apiv1 = 'api/search/aql' #you can change this API URL to any API method you'd like to use

url = app + apiv1

print(url)

# app_REPO_NAME = "generic-aubs-local"
# app_REPO_PATH_FOLDER = "vscode"
# app_SEARCH_ARTIFACT_NAME = "vscode.exe"
app_aql_payload = 'items.find( \
                                                { \
                                                    "repo":{"generic-aubs-local"}, \
                                                    "path":{"$match":"vscode"}, \
                                                    "name":{"VSCodeUserSetup-x64-1.44.2.exe"}' \
                                                '}' \
                                            ').sort(' \
                                                    '{' \
                                                        '{"$desc":["created"]}' \
                                                    '}' \
                                            ').limit(1)'


r = requests.post(url, auth = (username, apikey), data=app_aql_payload, verify=False) # ONLY USE IN PRE-PRODUCTION


if r.status_code == 200:
  print(r.content)
else:
  print("Fail")
  response = json.loads(r.content)
  print(response["errors"])

  print( "x-request-id : " + r.headers['x-request-id'] )
  print( "Status Code : " + r.status_code)


  ##########################################################################################################################################

  import requests
  host = 'https://artifactory.com/artifactory'

  from artifactory import build_url
  build_url = '%/api/search/aql' % (host)


app_aql_payload = 'items.find(' \
                                                '{' \
                                                    '{"repo":{"generic-aubs-local"},' \
                                                    '"path":{{"$match":"vscode"}},' \
                                                    '"name":"VSCodeUserSetup-x64-1.44.2.exe"}' \
                                                '}' \
                                            ').sort(' \
                                                    '{' \
                                                        '{"$desc":["created"]}' \
                                                    '}' \
                                            ').limit(1)'

response = response.json()
print(response)