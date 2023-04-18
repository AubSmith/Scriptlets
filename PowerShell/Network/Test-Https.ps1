# Create HTTPS connection
$GHE_HTTPS = [System.Net.WebRequest]::Create('https://www.google.com')

# Get the response status code
$GHE_Resp = [int]$GHE_HTTPS.GetResponse().StatusCode

#Output status code
Write-Host $GHE_Resp
