workflow get-disabled {
    Search-ADAccount -AccountDisabled |
    Select-Object -Property DistinguishedName |
    Export-Csv -Path c:ADReportsDisabledAccounts.csv -NoTypeInformation
   }
    
   
workflow get-expired {   
    Search-ADAccount -AccountExpired |
    Select-Object -Property DistinguishedName |
    Export-Csv -Path c:ADReportsExpiredAccounts.csv -NoTypeInformation
   }
    
   
workflow get-passwordneverexpire {   
    Search-ADAccount -PasswordNeverExpires |
    Select-Object -Property DistinguishedName |
    Export-Csv -Path c:ADReportsPsswdNeverExpireAccounts.csv -NoTypeInformation
   }
   
    
workflow get-ADReport {   
    parallel {
      get-disabled
      get-expired
      get-passwordneverexpire
     }
   }
