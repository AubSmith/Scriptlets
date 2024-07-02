# PowerShell funtion that writes the time and then does a ping test to a specified IP address.
# The function will then write the results to a file.
function Get-PingTestResult {
    param (
        [string]$IPAddress,
        [string]$OutputFile
    )

    $currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $pingResult = Test-Connection -ComputerName $IPAddress -Count 4

    $result = @"
Time: $currentTime
Ping Test Result:
IP Address: $IPAddress
Ping Success: $($pingResult.PSComputerName -contains $IPAddress)
Average Response Time: $($pingResult.ResponseTime | Measure-Object -Average).Average ms
"@

    $result | Out-File -FilePath $OutputFile -Append
}
