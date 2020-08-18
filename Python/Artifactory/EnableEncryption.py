#!/usr/bin/env python

# .\ArtifactoryAutoTest "oat"
# python .\Artifactory.py

# Import the required modules
import configparser, json, requests, sys


# Assign variables based on input parameters
env = sys.argv[1]

# Read the environment settings from Artifactory.ini
config = configparser.ConfigParser() 
config.readfp(open(r'.\Config\A:Artifactory.ini'))


# Load credentials
username = config.get('User', 'UserName')
token = config.get('Token', 'Token')

# Load Artifactory environment and build URL
Artifactory = config.get('Environment', env)
apiv1 = '/api/system/encrypt' #you can change this API URL to any API method you'd like to use

url = Artifactory + apiv1

# Create the header
headers = {'Authorization': 'Bearer ' + token}



url = Artifactory + apiv1
enableEncryption = requests.put(url, headers=headers)
if enableEncryption.status_code == 200:
  print('Encryption successfully enabled.')
else:
  print(enableEncryption.content)