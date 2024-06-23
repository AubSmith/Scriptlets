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
        $Manager = Get-ADUser -Identity $User1.Manager -Properties Name
        
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
    $User | Select-Object Name, SamAccountName, Manager, Group_Name | Export-Csv -Path $OutputFile -NoTypeInformation -Append

  }
} # Close Get_Member function


# Import AD group variables
try {
  if ($Application = "Value"){
    $Application_Groups = Get-Content -Path ".\Value\Value_Group.txt"
    $Role_Groups = Get-Content -Path ".\Value\Value_Role.txt"
  
  }
  elseif ($Application = "Artifactory"){
    $Application_Groups = Get-Content -Path ".\Artifactory\Artifactory_Group.txt"
    $Role_Groups = Get-Content -Path ".\Artifactory\Artifactory_Role.txt"
  
  }
}
catch {
  Write-Output "Either an invalid application has been specified or an unexpected error has occurred"
  Write-Output "$_.exception"
  
  Exit 1
}


# Create the CSV files for the current review period
$Month = Get-Date -Format "yyyy-MM"

# Working file of extracted users
$OutputFile = ".\$Application\Working\$Application'_'$Month.csv"

# Report to be reviewed by line managers
$UsersForReview = ".\$Application\$Application'_'$Month'_Review'.csv"


##### 1. Extract all members of application role groups #####
try {
  Get_Member -AD_Group $Role_Groups

  # Rename the file to denote extract as role group
  Rename-Item -Path $OutputFile -NewName "$Application'_Role_Groups_'$Month.csv"

}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 2. Extract all members from application access groups #####
try {
  Get_Member -AD_Group $Application_Groups

}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 3. Flag users that are members of more than one application access group #####
try {
  Write-Output "Members of multiple application access groups `n" | Add-Content -Path $UsersForReview

  # Import the CSV and filter for SamAccountNames appearing more than once
  $CsvFilter = Import-Csv -Path $OutputFile -Header "Name","SamAccountName","Manager","Group Name"
  $DuplicateUsers = $CsvFilter | Group-Object -Property SamAccountName | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Group

  if ($Null -ne $DuplicateUsers ) {
    $DuplicateUsers | ConvertTo-Csv | Add-Content -Path $UsersForReview
  }
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 4. Flag users that are not members of application role groups #####
try {
  Write-Output "`n Members of application access groups that are not members of application role groups `n" | Add-Content -Path $UsersForReview

  # Define the paths to your CSV files and the output log file
  $Role_Group = ".\$Application\Working\$Application'_Role_Groups_'$Month.csv"

  # Import the role group CSV file and select the SamAccountName column
  $RoleGrpSamActNames = @(Import-Csv -Path $Role_Group | Select-Object -ExpandProperty SamAccountName)

  $CsvRoleGrpFilter = Get-Content $OutputFile
  $CsvRoleGrpFilter | Select-String -Notmatch $RoleGrpSamActNames | Add-Content -Path $UsersForReview

  }
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 5. Flag all users that have been added in the last three months #####
try {
  Write-Output "`n Members of application access groups added since the last review" | Add-Content -Path $UsersForReview

  # Open the CSV extract for the previous review period
  $PreviousExtractRun = (Get-Date).AddMonths(-3).ToString("yyyy-MM")
  $PreviousCsvExtract = ".\$Application\Working\Prev_$Application'_'$PreviousExtractRun.csv"

  Compare-Object (Get-Content $PreviousCsvExtract) -DifferenceObject (Get-Content $OutputFile) -PassThru | Where-Object SideIndicator -eq '=>' | Add-Content $UsersForReview
}
catch {
  Write-Output "$_.exception"
  Exit 1
}


##### 6. E-mail #####



##### 7. Tidy up #####

