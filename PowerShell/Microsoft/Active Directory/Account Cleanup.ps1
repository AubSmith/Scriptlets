# Disabled accounts:
Search-ADAccount -AccountDisabled |
Select-Object -Property DistinguishedName |
Export-Csv -Path c:ADReportsDisabledAccounts.csv -NoTypeInformation

# Expired accounts:
Search-ADAccount -AccountExpired |
Select-Object -Property DistinguishedName |
Export-Csv -Path c:ADReportsExpiredAccounts.csv -NoTypeInformation

# Non-expiring passwords:
Search-ADAccount -PasswordNeverExpires |
Select-Object -Property DistinguishedName |
Export-Csv -Path c:ADReportsPsswdNeverExpireAccounts.csv -NoTypeInformation
