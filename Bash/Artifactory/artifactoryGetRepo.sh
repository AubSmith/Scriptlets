#! /bin/bash

curl -uusername:token https://artifactory.com/artifactory/api/repositories?packageType=rpm
curl -uusername:token https://artifactory.com/artifactory/api/repositories?type=local

curl -uusername:token 'https://artifactory.com/artifactory/api/repositories?packageType=rpm&type=local'