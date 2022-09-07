#!/usr/bin/bash

LDSEARCH="ldapsearch"
SERVER="ldap.corp.waynecorp.com"
PORT=3268
ADUSER="esmith@corp.waynecorp.com"

read -sp "Enter password for ${ADUSER}: " ADPASS

echo "Password ${ADPASS}"

${LDSEARCH} -v -h ${SERVER} -p 3268 -D "${ADUSER}" -w ${ADPASS}  -b "DC=corp,DC=waynecorp,DC=com" "(cn=${line})"

exit 0
