workflow get-ADReport {
    parallel {
     inlinescript {c:adreportsget-disabledaccount.ps1}
     inlinescript {c:adreportsget-expiredaccount.ps1}
     inlinescript {c:adreportsget-passwordNexpire.ps1  }
   }   
}
