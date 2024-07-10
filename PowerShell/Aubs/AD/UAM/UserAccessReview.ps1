[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$application
)


function Get_Member {
  param(
    [parameter(mandatory=$true)]
    $adGroups
  )

  $adGroups | ForEach-Object{
    $adGroup = $_
    #Get all the members of the filtered AD group
    $members = Get-ADGroupMember -Identity $adGroup | Get-ADUser -Properties *

    $results = @()

    ForEach($member in $members){
      try {
      
      # For each member of the AD group, get the user's Name, Sam Account Name, Manager, and Manger's e-mail address
      $result = [PSCustomObject] @{
          memberName = $member.Name
          memberSamAccountName = $member.SamAccountName
          memberManagerName = if ([string]::IsNullOrEmpty($member.Manager)) { "None" } else { (Get-ADUser $($member.Manager) -Properties * | Select-Object -ExpandProperty Name) }
          memberManagerEmail = if ([string]::IsNullOrEmpty($member.Manager)) { "None" } else { (Get-ADUser $($member.Manager) -Properties * | Select-Object -ExpandProperty EmailAddress) }
          memberGroupName = $adGroup
          }
      }
      catch {
        Write-Output "$_.exception"
        Exit 1
          
      }
    $results += $result
    }

  RETURN $results
  }
} # Close Get_Member function


# Import AD group variables
try {
  if (${application} = "Wayne"){
    $applicationGroups = Get-Content -Path ".\Wayne\Wayne_Group.txt"
    $roleGroups = Get-Content -Path ".\Wayne\Wayne_Role.txt"
  
  }
  elseif (${application} = "Artifactory"){
    $applicationGroups = Get-Content -Path ".\Artifactory\Artifactory_Group.txt"
    $roleGroups = Get-Content -Path ".\Artifactory\Artifactory_Role.txt"
  
  }
}
catch {
  Write-Output "Either an invalid ${application} has been specified or an unexpected error has occurred"
  Write-Output "$_.exception"
  
  Exit 1
}


# Calculate current review period
$month = Get-Date -Format "yyyy-MM"

# Calculate previous review period
$previousExtractRun = (Get-Date).AddMonths(-3).ToString("yyyy-MM")

# Record all users with current application access
$currentExtract = ".\${application}\Working\${application}_${month}.csv"

# Report to be reviewed by line managers
$usersForReview = ".\${application}\Working\${application}_${month}_Review.csv"


##### 1. Extract all members of application role groups #####
$roleGroupUsers = try {
  Get_Member -adGroups $roleGroups
  
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 2. Extract all members from application access groups #####
$applicationGroupUsers = try {
  Get_Member -adGroups $applicationGroups

}
catch {
  Write-Output "$_.exception"
  Exit 1
}
 
try {
  $applicationGroupUsers | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $currentExtract
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 3. Flag users that are members of more than one application access group #####
try {
  Write-Output "Members of multiple ${application} access groups`n" | Add-Content -Path $usersForReview

  # Filter for SamAccountNames appearing in more than one application access group
  $duplicateUsers = $applicationGroupUsers | Group-Object -Property memberSamAccountName | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Group
    

  if ($Null -ne $duplicateUsers ) {
    $duplicateUsers | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $usersForReview
  }
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 4. Flag users that are not members of application role groups #####
try {
  Write-Output "`n`nMembers of application access groups that are not members of application role groups`n" | Add-Content -Path $usersForReview

  # Import the array of role group objects and select the memberSamAccountName property
  $roleGroupSamActNames = $roleGroupUsers | Select-Object -Property memberSamAccountName

  $applicationGroupUsers | Where-Object { $_.memberSamAccountName -notin $roleGroupSamActNames.memberSamAccountName } | ConvertTo-Csv -NoTypeInformation | Add-Content -Path $usersForReview

  }
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 5. Flag all users that have been added in the last three Months #####
try {
  Write-Output "`n`nMembers of ${application} access groups added since the last review`n" | Add-Content -Path $usersForReview

  Compare-Object (Get-Content ".\${application}\Working\${application}_${previousExtractRun}.csv") -DifferenceObject (Get-Content $currentExtract) -PassThru | Where-Object SideIndicator -eq '=>' | Add-Content $usersForReview
 }
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 6. E-mail #####

$managerEmailAddress = 1

$sendEmailSplat = @{
  From = 'User01 <uar@waynecorp.com>'
  To = $managerEmailAddress
  Cc = ${Recipients}, 'Finance Application Support <finance_app_support@waynecorp.com>'
  Subject = 'Sending the Attachment'
  Body = "Forgot to send the attachment. Sending now."
  Attachments = $usersForReview
  Priority = 'High'
  DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
  SmtpServer = 'smtp.fabrikam.com'
}
Send-MailMessage @sendEmailSplat

##### 7. Tidy up #####

# Move the previous extract file and the to the archive folder
try {
  Move-Item -Path ".\${application}\Working\${application}_${previousExtractRun}.csv" -Destination ".\${application}\Archive"
  Move-Item -Path ".\${usersForReview}" -Destination ".\${application}\Archive"
}
catch {
  Write-Output "$_.exception"
  Exit 1
}
