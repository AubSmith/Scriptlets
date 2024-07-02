$computerName = $env:COMPUTERNAME
$localGroupName = "Administrators"

$group = [ADSI]("WinNT://$computerName/$localGroupName,group")

$group.Members() |
    foreach {
        $AdsPath = $_.GetType().InvokeMember('Adspath', 'GetProperty', $null, $_, $null)
        $a = $AdsPath.split('/',[StringSplitOptions]::RemoveEmptyEntries)
        $names = $a[-1] 
        $domain = $a[-2]

foreach ($name in $names) {
if ($name -eq "myuser") {
    $group.Remove("WinNT://$computerName/$domain/$name") }
    }
}  