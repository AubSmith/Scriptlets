folderId="183320"   # ID of Parent Folder
typeId="1724"   #  ID of Record Type
recordName="Record Name"   # Record Name (required)
recordDescription="Record Description"  # Record Description (optional)

rhost="host.company.com"   # Host URL
rport="22"   # Host Port
ruser="user"   # Host User
rpassword="myPassw0rd"   # Host Password
rparameters={\"Host\":\"$rhost\",\"Port\":\"$rport\",\"User\":\"$ruser\",\"Password\":\"$rpassword\"}

curl -s $auth -H "Accept: application/json" -H "Content-Type:application/x-www-form-urlencoded" -H "X-XSRF-TOKEN: $apitoken" -X POST  \
--data "name=$recordName&description=$recordDescription" --data-urlencode "custom=$rparameters" \
$url/rest/record/new/$folderId/$typeId

echo Done