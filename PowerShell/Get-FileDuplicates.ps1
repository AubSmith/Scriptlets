[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [switch]$Recurse = $false,
    [string]$Algorithm = 'SHA256'
)
 
Get-ChildItem $Path -Recurse:$Recurse | # Get the child items in the path
    Select -ExpandProperty FullName |   # Select only their full names
    ForEach-Object {                    # Hash each file
        Get-FileHash -Path $_ -Algorithm $Algorithm
    } | 
    Group-Object -Property Hash |       # Group by hash
    Where-Object { $_.Count -gt 1 } |   # Select only hashes with more than 1 file
    ForEach-Object {                    # Return a hash and a list of file names per duplicate
        [pscustomobject]@{ Hash = $_.Name; FullNames = $_.Group.Path }
    }