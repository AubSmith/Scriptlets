<##>
$URI = "https://$url/artifactory/$repo/file.zip"
$Source = ".\file.zip"

$Auth = Get-Credential -Message "Enter Credentials for  Artifactory"

#                              Basic user:pass
$headers = @{ Authorization = "Basic" }  

Invoke-RestMethod -Uri $URI -InFile $source -Method Put -Credential $Auth -Headers $headers
