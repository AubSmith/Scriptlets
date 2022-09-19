import requests

env = ""
token = ""
repo = ""
url = env + "/artifactory/api/replication/execute/" + repo
headers = { 'x-jfrog-art-api': token }

response = requests.post(url, data=json.dumps(jsonrepo), headers=headers, verify=False)