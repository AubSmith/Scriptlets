#!/usr/bin/env bash

# Cleaning up container = if container != exist, Podman = exit code 125. make expects each command to return 0 or it fails, so use wrapper script

ID="${@}"

podman stop ${ID} 2>/dev/null

if [[ $?  == 125 ]]
then
  # No such container
  exit 0
elif [[ $? == 0 ]]
then
  podman rm ${ID} 2>/dev/null
else
  exit $?
fi