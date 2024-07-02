# 1
delete C:\Windows\System32\drivers\SaiU0BD0.sys

# 2
Dism /online /Get-Drivers /Format:Table

pnputil /delete-driver oem0.inf /uninstall /force # [Published Name]
pnputil /delete-driver oem184.inf /uninstall /force # [Published Name]