import requests
import json

#enter credentials
# username = "admin"
# password = "password"


artifactory = "https://artifactory.url.com/artifactory/" #artifactory URL
# api = "api/trash/empty" #you can change this API URL to any API method you'd like to use, this URL will empty the trash can
api = 
url = artifactory + api

r = requests.post(url, auth = (username, password)) #this script is only for API methods that use POST
print r.content