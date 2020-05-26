#!/bin/bash

echo "Change to the appropriate directory"
cd /repo/dir/

sshpass -p 'password' scp -rp repo username@host:/repo/restore
sshpass -p 'password' scp -rp repo.artifactory-metadata username@ host:/repo/restore
