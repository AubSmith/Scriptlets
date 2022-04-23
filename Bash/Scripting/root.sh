#!/bin/bash

ROOT_UID=0

if [ "$UID" -eq "$ROOT_UID" ]
then
echo "Great! You are a root user"
else
echo "You are not the root user"
fi