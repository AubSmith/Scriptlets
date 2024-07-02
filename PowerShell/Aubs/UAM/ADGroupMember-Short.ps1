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

      # For each member of the AD group, get the user's name, samaccountname and manager
      $Users | ForEach-Object {
        try {

          $User1 = Get-ADUser -Identity $_.SamAccountName -Properties Manager
          $Manager = Get-ADUser -Identity $User1.Manager -Properties Name, 

          # Add the Manager property to the $User array
          $User1 | Add-Member -MemberType NoteProperty -Name "Manager" -Value $Manager.Name -Force

        }
        catch {
          # Add the Manager property to the $User array
          $User1 | Add-Member -MemberType NoteProperty -Name "Manager" -Value "No Manager specified in AD." -Force
        }

        # Add the GroupName property to the $User array
        $User1 | Add-Member -MemberType NoteProperty -Name "Group_Name" -Value $AD_Group -Force
        $User += $User1

      }
      $User | Select-Object Name, SamAccountName, Manager, Group_Name | Export-Csv -Path $Users_For_Review -NoTypeInformation -Append

    }
    catch {
      $AD_Group | Add-Content ".\Invalid_Role_Group.txt"
    }

  } # Close ForEach-Object
} # Close Get_Member function


# Import AD group variables
try {
    $Application_Groups = Get-Content -Path ".\Xero\Xero_Group.txt"
  
}
catch {
  Write-Output "Either an invalid {Application} has been specified or an unexpected error has occurred"
  Write-Output "$_.exception"
  
  Exit 1
}


# Create the CSV files for the current review period
$Month = Get-Date -Format "yyyy-MM"


# Report to be reviewed by line managers
$Users_For_Review = ".\${Application}\${Application}_${Month}'_Review'.csv"


##### 1. Extract all members from {Application} access groups #####
try {
  Get_Member -AD_Group $Application_Groups

}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 2. E-mail #####
$Send_MailMessage_Splat = @{
  From = 'User01 <user01@fabrikam.com>'
  To = 'User02 <user02@fabrikam.com>', 'User03 <user03@fabrikam.com>'
  Subject = 'Sending the Attachment'
  Body = "Forgot to send the attachment. Sending now."
  Attachments = '.\data.csv'
  Priority = 'High'
  DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
  SmtpServer = 'smtp.fabrikam.com'
}
Send-MailMessage @Send_MailMessage_Splat


##### 3. Tidy up #####

