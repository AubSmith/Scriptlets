[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$Application
)


function Get_Member {
  param(
    [parameter(mandatory=$true)]
    $AD_Groups
  )
  # Loop through the list of AD groups and filter foreach group
  $AD_Groups | ForEach-Object {

    try {
      $AD_Group = $_


      # Get all the members of the filtered AD group
      $Users = Get-ADGroupMember -Identity $AD_Group |
        Select-Object Name, SamAccountName

      # Create an empty array to store user information
      $User = @()

      # For each member of the AD group, get the user's name, samaccountname, manager and manager's e-mail address
      $Users | ForEach-Object {
        try {

          $User1 = Get-ADUser -Identity $_.SamAccountName -Properties Manager
          $Manager = Get-ADUser -Identity $User1.Manager -Properties Name, EmailAddress

          # Add the Manager property to the $User array
          $User1 | Add-Member -MemberType NoteProperty -Name "Manager" -Value $Manager.Name -Force
          $User1 | Add-Member -MemberType NoteProperty -Name "Manager_EmailAddress" -Value $Manager.EmailAddress -Force

          # Save the manager e-mail address in an array so that they can be e-mailed the report to review
          $Manager_Emails | Add-Member -MemberType NoteProperty -Name "Manager_EmailAddress" -Value $Manager.EmailAddress -Force
          $Manager_Emails = $Manager_Emails | Select-Object -Unique

        }
        catch {
          # Flag missing Manager and Manager_Emailaddress properties to the $User array
          $User1 | Add-Member -MemberType NoteProperty -Name "Manager" -Value "No Manager specified in AD." -Force
          $User1 | Add-Member -MemberType NoteProperty -Name "Manager_EmailAddress" -Value "No manager specified in AD." -Force

          $Manager_Emails | Add-Member -MemberType NoteProperty -Name $Null -Value $Manager.EmailAddress -Force

        }

        # Add the GroupName property to the $User array
        $User1 | Add-Member -MemberType NoteProperty -Name "Group_Name" -Value $AD_Group -Force
        $User += $User1

      }
      $User | Select-Object Name, SamAccountName, Manager, Manager_EmailAddress, Group_Name | Export-Csv -Path $Output_File -NoTypeInformation -Append

    }
    catch {
      $AD_Group | Add-Content ".\Invalid_Role_Group.txt"
    }

  } # Close ForEach-Object
} # Close Get_Member function


# Import AD group variables
try {
  if (${Application} = "Xero"){
    $Application_Groups = Get-Content -Path ".\Xero\Xero_Group.txt"
    $Role_Groups = Get-Content -Path ".\Xero\Xero_Role.txt"
  
  }
  elseif (${Application} = "Artifactory"){
    $Application_Groups = Get-Content -Path ".\Artifactory\Artifactory_Group.txt"
    $Role_Groups = Get-Content -Path ".\Artifactory\Artifactory_Role.txt"
  
  }
}
catch {
  Write-Output "Either an invalid {Application} has been specified or an unexpected error has occurred"
  Write-Output "$_.exception"
  
  Exit 1
}


# Create the CSV files for the current review period
$Month = Get-Date -Format "yyyy-MM"

# Working file of extracted users
$Output_File = ".\${Application}\Working\${Application}_${Month}.csv"

# Report to be reviewed by line managers
$Users_For_Review = ".\${Application}\${Application}_${Month}_Review.csv"

# Create e-mail array
$Manager_Emails = @()

##### 1. Extract all members of {Application} role groups #####
try {
  Get_Member -AD_Group $Role_Groups

  # Rename the file to denote extract as role group
  Rename-Item -Path $Output_File -NewName "${Application}_Role_Groups_${Month}.csv"

}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 2. Extract all members from {Application} access groups #####
try {
  Get_Member -AD_Group $Application_Groups

}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 3. Flag users that are members of more than one application access group #####
try {
  Write-Output "`n`nMembers of multiple {Application} access groups`n" | Add-Content -Path $Users_For_Review

  # Import the CSV and filter for SamAccountNames appearing more than once
  $Csv_Filter = Import-Csv -Path $Output_File -Header "Name","SamAccountName","Manager","Group Name"
  $Duplicate_Users = $Csv_Filter | Group-Object -Property SamAccountName | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Group

  if ($Null -ne $Duplicate_Users ) {
    $Duplicate_Users | ConvertTo-Csv | Add-Content -Path $Users_For_Review
  }
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 4. Flag users that are not members of application role groups #####
try {
  Write-Output "`n`nMembers of application access groups that are not members of application role groups`n" | Add-Content -Path $Users_For_Review

  # Define the paths to your CSV files and the output log file
  $Role_Group = ".\${Application}\Working\${Application}_Role_Groups_${Month}.csv"

  # Import the role group CSV file and select the SamAccountName column
  $Role_Grp_SamActNames = @(Import-Csv -Path $Role_Group | Select-Object -ExpandProperty SamAccountName)

  $Csv_Role_Grp_Filter = Get-Content $Output_File
  $Csv_Role_Grp_Filter | Select-String -Notmatch $Role_Grp_SamActNames | Add-Content -Path $Users_For_Review

  }
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 5. Flag all users that have been added in the last three Months #####
try {
  Write-Output "`n`nMembers of {Application} access groups added since the last review`n" | Add-Content -Path $Users_For_Review

  # Open the CSV extract for the previous review period
  $Previous_Extract_Run = (Get-Date).AddMonths(-3).ToString("yyyy-MM")
  $Previous_Csv_Extract = ".\${Application}\Working\Prev_${Application}_${Previous_Extract_Run}.csv"

  Compare-Object (Get-Content $Previous_Csv_Extract) -DifferenceObject (Get-Content $Output_File) -PassThru | Where-Object SideIndicator -eq '=>' | Add-Content $Users_For_Review
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 6. E-mail #####
$Send_MailMessage_Splat = @{
  From = 'User01 <user01@fabrikam.com>'
  To = $Manager_Emails
  Cc = ${Recipients}, 'Finance Application Support <finance_app_support@waynecorp.com>'
  Subject = 'Sending the Attachment'
  Body = "Forgot to send the attachment. Sending now."
  Attachments = '.\data.csv'
  Priority = 'High'
  DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
  SmtpServer = 'smtp.fabrikam.com'
}
Send-MailMessage @Send_MailMessage_Splat


##### 7. Tidy up #####

# Move the previous extract file and the to the archive folder
try {
  Move-Item -Path ".\${Application}\Working\Prev_${Application}_${Previous_Extract_Run}.csv" -Destination ".\${Application}\Archive"
  Move-Item -Path .\${Application}\${Application}_${Month}_Review.csv -Destination ".\${Application}\Archive"
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


# Delete application role group extract file
try {
  Remove-Item -Path ".\${Application}\Working\${Application}_Role_Groups_${Month}.csv"
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


# Rename the application access group extract file
try {
  Rename-Item -Path $Output_File -NewName "Prev_${Application}_${Month}.csv"
}
catch {
  Write-Output "$_.exception"
  Exit 1
}
