[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-RestMethod -Uri "https://api.statuspage.io/v1/pages/incidents.json" -Method Get -Header @{Authorization = "OAuth $token"} | ConvertTo-Json -Depth 10 | Out-File .\Test.txt