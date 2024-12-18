function Get-Token {
    param (
        [Parameter(Mandatory=$true)]
        [string]$token_url,
        [string]$header
    )
 
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $response = Invoke-RestMethod -Uri $token_url -Method Post -Headers @{ host = $header }

        return $response.access_token
    }
    catch {
        Write-Output "Error: " $_.Exception.Message
        Write-Output $_.ScriptStackTrace
        Exit 1
    }
}


function Get-Endpoint {
    param (
        [Parameter(Mandatory=$true)]
        [string]$token_url,
        [string]$header
    )
 
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $response = Invoke-RestMethod -Uri $token_url -Method Post -Headers @{ host = $header }

        $token = $response.access_token

        return $token
    }
    catch {
        Write-Output "Error: " $_.Exception.Message
        Write-Output $_.ScriptStackTrace
        Exit 1
    }
}

$ip_address = "",""
$environment = ""

try {
    foreach ($ip in $ip_address) {
        $token_response = Get-Token "https://$ip/token" $environment
    
    }
}
catch {
    Write-Output "Status Code:" $_.Exception.Response.StatusCode.value__
    Write-Output "Status Description:" $_.Exception.Response.StatusDescription
}

try {
    foreach ($ip in $ip_address) {
        $get_endpoint = Get-Endpoint "https://$ip/token" $environment $token_response.token


    
    }
}
catch {
    Write-Output "Status Code:" $_.Exception.Response.StatusCode.value__
    Write-Output "Status Description:" $_.Exception.Response.StatusDescription
}