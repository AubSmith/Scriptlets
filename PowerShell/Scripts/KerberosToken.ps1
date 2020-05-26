klist


# https://docs.microsoft.com/en-us/dotnet/api/system.security.principal.windowsidentity?redirectedfrom=MSDN&view=dotnet-plat-ext-3.1
$token = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$token

$groupSIDS = $token.Groups
$groupSIDs[10]

$groupSIDS[10].Translate([System.Security.Principal.NTAccount])





$token = [System.Security.Principal.WindowsIdentity]::GetCurrent() # Get current user context
$groupSIDs = $token.Groups # Get SIDs in current Kerberos token
foreach($sid in $groupSIDs) { # for each of those SIDs...
            try { # try to..
                        Write-Host (($sid).Translate([System.Security.Principal.NTAccount])) # translate the SID to an account name
            }
            catch { # if we can't translate it...
                        Write-Warning ("Could not translate " + $sid.Value + ". Reason: " + $_.Exception.Message) # Output a warning and the corresponding exception
            }
}