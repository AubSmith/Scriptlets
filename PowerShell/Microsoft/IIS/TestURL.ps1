$url = 

try {
    $R = Invoke-WebRequest -Uri $url
}
catch {
    $_.Exception.Message
}