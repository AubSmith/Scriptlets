$PSDefaultParameterValues.Add('write-host:foregroundcolor',{get-random $([system.enum]::getvalues([system.consolecolor]))})
$PSDefaultParameterValues.Add('write-host:backgroundcolor',{get-random $([system.enum]::getvalues([system.consolecolor]))})