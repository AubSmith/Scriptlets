
Invoke-RestMethod has built-in deserialization. A JSON response is automatically parsed [pscustomobject] object. This is the same as piping an Invoke-WebRequest response to ConvertFrom-Json.

Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Headers @{Accept = 'application/json'}