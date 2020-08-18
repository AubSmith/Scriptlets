#!/usr/bin/env python

# .\ArtifactoryAutoTest "oat" "Aubs" "Aubs repo test" "maven"
# python .\Artifactory.py

# Import the required modules
import configparser, json, requests, sys


# Assign variables based on input parameters
env = sys.argv[1]
key = sys.argv[2]
description = sys.argv[3]
packagetype = sys.argv[4]

# Read the environment settings from Artifactory.ini
config = configparser.ConfigParser() 
config.readfp(open(r'.\Config\A:Artifactory.ini'))

# Verify that the requested repo packageType is valid

if packagetype == open('Artifactory.ini').read():
    print('This is a valid package type')
else:
    print('Invalid package type')


# Set the repo name

grpName = 'packageType' + '-' + 'key' + '-local'

# Build the JSON construct
jsonrepo = { 'key': grpName, 'rclass':'local', "description": description, 'packageType':packagetype }


# Load credentials
username = config.get('User', 'UserName')
token = config.get('Token', 'Token')

# Load Artifactory environment and build URL
Artifactory = config.get('Environment', env)
apiv1 = '/api/repositories/' #you can change this API URL to any API method you'd like to use

url = Artifactory + apiv1 + grpName

# Create the header
headers = {'Authorization': 'Bearer ' + token, "Content-Type": "application/json"}



# Delete the repo if it exists
testRepo = requests.put(url, header=headers)
if testRepo.status_code == 200:
  requests.delete(url, header=headers)
  print('Repo has been deleted')
else:
  print('This repo does not exist')

# Create the repo
createRepo = requests.put(url, header=headers)
if createRepo.status_code == 200:
  print('Repo created successfully')
else:
  print(createRepo.content)


# Construct security group JSON
jsongrp = {'name':grpName, 'description':description, 'realm':'Artifactory', 'realmAttributes':''}

apiv2 = '/api/security/groups/'

url = Artifactory + apiv2 + grpName
createGrp = requests.put(url, data=json.dumps(jsonrepo), headers=headers)
if createGrp.status_code == 200:
  print('Security group created successfully')
else:
  print(createGrp.content)


# Construct permissions JSON
jsonprm = {'name':grpName, 'repositories':grpName, }
principals={}
groups={}
groups[grpName] = "n","r"
principals['groups'] = groups

jsonprm['principals'] = principals
print(json.dumps(jsonprm))

apiv3 = '/api/security/permissions/'

url = Artifactory + apiv3 + grpName
createPrm = requests.put(url, data=json.dumps(jsonrepo), headers=headers)
if createPrm.status_code == 200:
  print('Security group created successfully')
else:
  print(createPrm.content)




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
