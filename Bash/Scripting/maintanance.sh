#!/bin/bash

echo -e "\n$(date "+%d-%m-%Y --- %T") --- Starting\n"

apt-get update
apt-get -y upgrade

apt-get -y autoremove
apt-get autoclean

echo -e "\n$(date "+%T") \t Done!"