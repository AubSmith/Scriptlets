$token = ""
$url = ""
$repo = ""

headers=@{} $headers.Add("x-jfrog-art-api", "$token")
Invoke-RestMethod -Uri "https://$url/artifactory/api/replication/execute/$repo" -Method POST -Headers $headers
