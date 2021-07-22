'''

ArtifactoryProxyUpdate.py

--proxy=MYPROXYHOST
-- repoName=generic-homebrew-remote

Typical command line syntax.

python3 ArtifactoryProxyUpdate.py --repoName=generic-homebrew-remote --proxy=MYPROXYHOST
'''

import requests
import json
import sys
import argparse
import configparser

def getOptions(args=sys.argv[1:]):

  text = 'This program will provide admin functions for JFrog products.'
  parser = argparse.ArgumentParser(description=text)

  parser.add_argument("-v", "--verbose", dest="verbose", help="Entering verbose mode", action="store_true")
  parser.add_argument("-f", "--force", dest="force", help="Force certain commands from continuing", action="store_true")
  parser.add_argument("-a", "--artifactory", dest="artifactory", default="artifactory-test", help="set Artifactory instance")
  parser.add_argument("-r", "--repo", dest="repoName", help="Name of repository to use.")
  parser.add_argument("-o", "--proxy", dest="proxyName", help="Name of proxy to use.")
  parser.add_argument("-p", "--ping", dest="ping", help="Ping Artifactory.", action="store_true")
  parser.add_argument("-l", "--list", dest="list", help="List System Configuration", action="store_true")

  options = parser.parse_args(args)

  return options

def load_settings(config, env='artifactory-test'):
    
    config = {
        "url": config[env]['baseurl'], 
        "username": config[env]['username'],
        "password": config[env]['password'],
        "sslKey": config['ssl']['pki'],
        "jsonHeader": config['headers']['json'],
      }
    
    url = config.get("url") + "artifactory/api/"
    config["url"] = url

    return (config)

def printRequestDict(requestDict):
  print (requestDict)

  url = requestDict.get("url")
  username = requestDict.get("username")
  password = requestDict.get("password")
  sslKey = requestDict.get("sslKey")
  jsonHeader = requestDict.get("jsonHeader")

  print(url)
  print(username)
  print(password)
  print(sslKey)
  print(jsonHeader)

  return

def pingArtifactory(options, requestDict):

  if options.verbose:
    print(requestDict)

  sslKey = requestDict.get("sslKey")
  url = requestDict.get("url") + "system/ping"

  ping = requests.get(url, verify=sslKey)

  if options.verbose:
    if ping.status_code == 200:
      print("Artifactory is OK.")
    else:
      print(ping.text)
      exit ()

def getSystemConfiguration(options, requestDict):

  sslKey = requestDict.get("sslKey")
  repoName = requestDict.get("repoName")
  username = requestDict.get("username")
  password = requestDict.get("password")
  url = requestDict.get("url")

  if options.verbose:
    print(requestDict)

  url = requestDict.get("url") + "system/configuration"

  listSystemConfiguration = requests.get(url, verify=sslKey, auth=(username, password))
  
  print (listSystemConfiguration.text)

def getRepositories(options, requestDict):

  sslKey = requestDict.get("sslKey")
  username = requestDict.get("username")
  password = requestDict.get("password")
  url = requestDict.get("url")

  urlAllRepos = url + 'repositories'
  print(urlAllRepos)

  allRepoInfo = requests.get(urlAllRepos, verify=sslKey)
  json_data = allRepoInfo.json()

  # print(json.dumps(json_data, indent=1))
  #isObjectList = isinstance(json_data, list)
  #print(isObjectList)

  print(len(json_data))

  ''' List all keys in LIST '''
  for i in json_data:
    repoKey=i['key']
    repoType=i['type']

    if repoType == 'REMOTE':
      print(repoKey)

def pxy_configured(options, requestDict, repoKey):

  sslKey = requestDict.get("sslKey")
  username = requestDict.get("username")
  password = requestDict.get("password")
  url = requestDict.get("url")

  urlRemoteInfo = url + 'repositories/' + repoKey
  remoteInfo = requests.get(urlRemoteInfo, verify=sslKey, auth=(username, password))
  jsonRemoteInfo = remoteInfo.json()

  if "proxy" in jsonRemoteInfo:
    proxy = jsonRemoteInfo["proxy"]
  else:
    proxy = 'NOPROXY'

  return proxy

def check_repository_type(options, requestDict):
  
  sslKey = requestDict.get("sslKey")
  repoName = options.repoName
  username = requestDict.get("username")
  password = requestDict.get("password")
  url = requestDict.get("url")

  urlRepName = url + 'repositories/' + repoName
  
  if options.verbose:
    print('urlRepName = ' + urlRepName)

  # Get info from Artifactory
  repoInformation = requests.get(urlRepName, verify=sslKey, auth=(username, password))
  jsonRepoInfo = repoInformation.json()
  
  # Check if variable is a dict.
  if options.verbose:
    if isinstance(jsonRepoInfo,dict):
      print("jsonRepoInfo is a dictionary.")

      if options.verbose:
        print(json.dumps(jsonRepoInfo, indent=2))
        print("Repository Type: " + jsonRepoInfo.get('rclass'))
      else:
        print("jsonRepoInfo is not a dictionary.")
    
  repoType = jsonRepoInfo.get('rclass')
  return repoType

def updProxy(options, requestDict):

  print("Starting in function updProxy")

  # Define required variables.
  sslKey = requestDict.get("sslKey")
  repoName = options.repoName
  username = requestDict.get("username")
  password = requestDict.get("password")
  url = requestDict.get("url")
  headers = requestDict.get("headers")
  uri = url + 'repositories/' + repoName

  # Get current repository information.
  repoInformation = requests.get(uri, verify=sslKey, auth=(username, password))
  jsonRepoInfo = repoInformation.json()

  jsonRepoInfo["proxy"] = options.proxyName

  # Send update JSon back to Artifactory.
  updRepoInfo=requests.post(uri, headers=headers, auth=(username, password), verify=sslKey, json=jsonRepoInfo)

  # Lets get the updated json back and confirm the proxy has been updated correctly.
  repoInformation = requests.get(uri, verify=sslKey, auth=(username, password))
  jsonRepoInfo = repoInformation.json()

  retProxyName = jsonRepoInfo.get('proxy')
  
  if retProxyName == options.proxyName:
    print ("Proxy looks to be updated. " + jsonRepoInfo["proxy"])
  else:
    print('Looks like an error. Please name of updated proxy is correct.')


if __name__ == "__main__":
  
  # Load input parameters loaded into getZOptions function.
  options = getOptions(sys.argv[1:])

  # Load configparser
  requestDict = configparser.ConfigParser()
  requestDict.read('./../ini/jfrog.ini')
  requestDict = load_settings(requestDict,options.artifactory)

  # Check Force option. Give message if it is turned on.
  if options.force:
    print("FORCE is turned ON.")

  # Print some settings if verbose is switched on.
  if options.verbose:
    print(requestDict)
    print(options)

  if options.ping:
    
    if options.verbose:
      print("Pinging Artifactory.")

    pingArtifactory(options, requestDict)

  if options.list:
    getSystemConfiguration(options, requestDict)

  if options.repoName:
    repoType=check_repository_type(options, requestDict)
    currentProxy=pxy_configured(options, requestDict, options.repoName)

    print('repoName=' + options.repoName)
    print('currentProxy=' + currentProxy)
    print('repoType=' + repoType)

    updProxy(options, requestDict) 

