import-module grouppolicy

function IsNotLinked($xmldata){
    If ($xmldata.GPO.LinksTo -eq $null) {
        Return $true
    }
    
    Return $false
}

$unlinkedGPOs = @()

Get-GPO -All | ForEach { $gpo = $_ ; $_ | Get-GPOReport -ReportType xml | ForEach { If(IsNotLinked([xml]$_)){$unlinkedGPOs += $gpo} }}

If ($unlinkedGPOs.Count -eq 0) {
    "No Unlinked GPO's Found"
}
Else{
    $unlinkedGPOs | Select DisplayName,ID | ft
}