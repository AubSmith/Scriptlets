set-location cert:
cd currentuser
gci -Recurse | ? subject -Match 'Microsoft'
cd /
dir cert:\currentuser -Recurse | ? subject -Match 'Microsoft'
cd currentuser
gci -Recurse | ?  NotAfter -LT "01/03/2018"
GCI -Recurse | ? NotAfter -LT (Get-Date)
DIR
Invoke-Item cert:
GCI -Recurse | ? { !$_.psiscontainer -and $_.NotAfter -lt (Get-Date)} | ft notafter, thumbprint, subject, -Autosize -wrap
GCI -Recurse -ExpiringInDays 30
GCI -Recurse -ExpiringInDays 240
GCI -Recurse -ExpiringInDays 240 -r | select subject, notafter | sort notafter | ft notafter, subject -A -wr
PS Cert:\currentuser> get-alias
GCI -ExpiringInDays 240 -r | select subject, notafter | sort notafter | ft notafter, subject -A -wr
