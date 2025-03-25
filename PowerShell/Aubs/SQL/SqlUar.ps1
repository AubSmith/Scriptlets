[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$application
)

$dir = "C:\Users\administrator\Desktop\UAM"
Push-Location $dir

function Get_Member {
  param(
    [parameter(mandatory=$true)]
    $adGroups
  )

  # Loop through the list of AD groups and filter for each group
  $adGroups | ForEach-Object{
    try {
      $results = @()

      $adGroup = $_
      #Get all the members of the filtered AD group
      $members = Get-ADGroupMember -Identity $adGroup | Get-ADUser -Properties *

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
          Write-Output $_
          Exit 1

        }
      $results += $result
      }
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    Write-Output "The group, ${adGroup} does not exist." | Add-Content -Path $groupsForReview
    }

  RETURN $results
  } # Close ForEach-Object loop
} # Close Get_Member function


# Import AD group variables
try {
  if (${application} -imatch "Vault"){
    $applicationGroups = Get-Content -Path ".\${application}\${application}_Group.txt"
    $roleGroups = Get-Content -Path ".\${application}\${application}_Role.txt"
    $recipients = Get-Content -Path ".\${application}\email.txt"
  
  }
  elseif (${application} -imatch "Artifactory"){
    $applicationGroups = Get-Content -Path ".\${application}\${application}_Group.txt"
    $roleGroups = Get-Content -Path ".\${application}\${application}_Role.txt"
    $recipients = Get-Content -Path ".\${application}\email.txt"
  
  }
}
catch {
  Write-Output $_
  
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

# Group report to be viewed by application support
$groupsForReview = ".\${application}\Working\${application}_Grp_${month}_Review.csv"


##### 1. Extract all members of application role groups #####
$roleGroupUsers = try {
  Get_Member -adGroups $roleGroups
  
}
catch {
  Write-Output $_
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
  Write-Output $_
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
  Write-Output $_
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
  Write-Output $_
  Exit 1
}


##### 5. Flag all users that have been added in the last three Months #####
try {
  Write-Output "`n`nMembers of ${application} access groups added since the last review`n" | Add-Content -Path $usersForReview

  Compare-Object (Get-Content ".\${application}\Working\${application}_${previousExtractRun}.csv") -DifferenceObject (Get-Content $currentExtract) -PassThru | Where-Object SideIndicator -eq '=>' | Add-Content $usersForReview
 }
catch {
  Write-Output $_
  Exit 1
}


##### 6. E-mail #####

### User Access Review ###
# extract manager e-mail addresses
$managerEmailAddress = @($applicationGroupUsers | ForEach-Object { $_.memberManagerEmail } | Where-Object { $_ -ne "None" } | Select-Object -Unique)


$sendEmailSplat = @{
  From = 'User01 <uar@waynecorp.com>'
  To = $managerEmailAddress
  Cc = ($recipients + ',' + 'finance_app_support@waynecorp.com')
  Subject = "${application} User Aaccess Review - ${month}"
  Body = "Please find herewith attached the list of users with access to the ${application} application for your review. `n`nThis is an automated message. Please do not reply to this email."
  Attachments = $usersForReview
  Priority = 'High'
  DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
  SmtpServer = 'smtp.fabrikam.com'
}

Send-MailMessage @sendEmailSplat

### Missing groups ###

if (Test-Path $groupsForReview) {
  $sendEmailSplat = @{
    From = 'User01 <uar@waynecorp.com>'
    To = 'Finance Application Support <finance_app_support@waynecorp.com>'
    Subject = "${application} UAR - Invalid groups detected"
    Body = "The attachment contains a list of AD groups specified in the quarterly ${application} UAR process that do not exist."
    Attachments = $groupsForReview
    Priority = 'High'
    DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
    SmtpServer = 'smtp.fabrikam.com'
  }
  
  Send-MailMessage @sendEmailSplat
}


##### 7. Tidy up #####

# Move the previous extract file and the to the archive folder
try {
  Move-Item -Path ".\${application}\Working\${application}_${previousExtractRun}.csv" -Destination ".\${application}\Archive"
  Move-Item -Path ".\${usersForReview}" -Destination ".\${application}\Archive"
  Move-Item -Path ".\${groupsForReview}" -Destination ".\${application}\Archive"
}
catch {
  Write-Output $_
  Exit 1
}



# Description: This script will return a list of all users and roles that have access to a report in SSRS.
# The script will return the RoleName, UserName and Path of the report.
$sql = @"
    SELECT
        R.RoleName,
        U.UserName,
        C.Path
    FROM
        ReportServer.dbo.Catalog C WITH (NOLOCK)    --Parent
        JOIN
        ReportServer.dbo.Policies P WITH (NOLOCK) ON C.PolicyID = P.PolicyID
        JOIN
        ReportServer.dbo.PolicyUserRole PUR WITH (NOLOCK) ON P.PolicyID = PUR.PolicyID 
        JOIN
        ReportServer.dbo.Users U WITH (NOLOCK) ON PUR.UserID = U.UserID 
        JOIN
        ReportServer.dbo.Roles R WITH (NOLOCK) ON PUR.RoleID = R.RoleID
    WHERE
        C.Type = 1
"@

# Import the SQL Server module
Import-Module SqlServer

#Connect to SQL Server and extract user access information
# Connection string to the SSRS database
$connectionString = "Server=SSRSServer;Database=ReportServer;Integrated Security=True"
$sqlResult | Invoke-Sqlcmd -ConnectionString $connectionString | Export-Csv -Path ".\SSRS_Access.csv" -NoTypeInformation

$sqlResult | Select-Object -Property RoleName, UserName, Path | Export-Csv -Path ".\SSRS_Access.csv" -NoTypeInformation


# Recursively explore AD groups