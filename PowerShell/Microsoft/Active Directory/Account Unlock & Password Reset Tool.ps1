<#
  Author:   Matt Schmitt
  Date:     12/4/12 
  Version:  2.0 
  From:     USA 
  Email:    ithink2020@gmail.com 
  Website:  http://about.me/schmittmatt
  Twitter:  @MatthewASchmitt
  
  Description
    A tool checking for Locked Accounts in AD, checking if a user is locked out, unlocking the user's 
    account and for resetting a user's password.  
  
  UPDATED 12/11/12
    Added some Error Handling
        Check if server is available. If not, skip sever and do not try to exicute code on it.
        Changed the way I handled the $servers array. This is so I can remove a server if it is unavailable.
        Check if supplied user is in AD.  If not, Ask the admin to re-enter username
    Added Comment blocks for each section.
  
  UPDATED 12/10/12
    Added the use of functions to clean up repeated code.
    Cleaned up Password reset code to use a foreach that looks at the $servers array.
    Added some needed Comments
  
  UPDATED 12/4/12
    Cleaned up Checking LockedOut Status code - replaced with foreach statement that looks at $Servers array
    Cleaned up Unlock code - replaced with foreach statement that looks at $Servers array
    Cleaned up Get pwdlastset date - rewrote to use the method I was using for other lookups for AD properties.

#>

#Imports Active Directory Module
Import-Module ActiveDirectory

Write-Host ""
Write-Host "PowerShell AD Password Tool"
Write-Host ""
Write-Host "This tool displays the Exparation Date of a user's Password and thier Lockedout"
Write-Host "Status.  It will then allow you to unlock and/or reset the password."
Write-Host ""
Write-Host ""


###########################
##       FUNCTIONS       ##
###########################


#################################
###  unlockAndCheck function  ###
#################################

#This fuction unlocks defined user account on the DCs defined in the $servers array, then checks the 
#local DC to make sure it did get unlocked.
function unlockAndCheck {

    foreach ($server in $servers) {

        Try {
                    
            Write-Host "Unlocking account on $server"
            Unlock-ADAccount -Identity $user -server $server
        }catch{

            

        }

    }         
                                
                
                
    #Get Lockedout status and set it to $Lock
    $Lock = (Get-ADUser -Filter {samAccountName -eq $user } -Properties * | 
                    Select-Object -expand lockedout)

    Write-Host ""

    #Depending on Status, tell user if the account is locked or not.
    switch ($Lock) {
                        "False" { Write-Host "$user is unlocked." }
                        "True" { Write-Host "$user is LOCKED Out." }
                   }
}



############################
###  resetPass function  ###
############################

#This function resets the password for the defined user on the DCs define in the $server array.
function resetPass {
    
    $newpass = (Read-Host -AsSecureString "Enter user's New Password")
                
    
    foreach ($server in $servers) {

        Write-Host "Resetting Password on $server"
        Set-ADAccountPassword -Server $server -Identity $user -NewPassword $newpass
    
    }            
    
                                
    Write-Host ""
    Write-Host "Password for $user has been reset."
    Write-Host ""

}

###########################
##     End FUNCTIONS     ##
###########################




###########################
##   Define DCs to use   ##
###########################

<#
    For our company we have several DCs across the globe.  Since the DCs at each site update each other
    farely quickly, I'm only going to define one DC per site.  This will save time in checking the lockedOUt
    status, unlocking the user and resetting the password.

    ---> IMPORTANT: Update $servers array list as DCs change!!!

#>

#Creating Empty $servers Array
$servers = New-Object System.Collections.ArrayList

#Creating Empty $unavailable Array
$unavailable = New-Object System.Collections.ArrayList

#Assign Domain Controllers to $servers Array
$servers.add("DC01.your.domain.com") | out-null
$servers.add("DC02.your.domain.com") | out-null

# NOTE: can can add more, just add them idividually like I did above.



##################################################
##   Check for Any Locked User Accounts in AD   ##
##################################################

#Counts how many locked account there are on the local DC and sets it to $count
$count = Search-ADAccount –LockedOut | where { $_.Name -ne "Administrator" -and $_.Name -ne "Guest" } | 
    Measure-Object | Select-Object -expand Count


#If there are locked accounts (other than Administrator and Guest), then this will display who is locked out.
If ( $count -gt 0 ) {

    Write-Host "Current Locked Out Accounts on your LOCAL Domain Controller:"
    Search-ADAccount –LockedOut | where { $_.Name -ne "Administrator" -and $_.Name -ne "Guest" } | 
        Select-Object Name, @{Expression={$_.SamAccountName};Label="Username"},@{Expression={$_.physicalDeliveryOfficeName};Label="Office Location"},@{Expression={$_.TelephoneNumber};Label="Phone Number"},@{Expression={$_.LastLogonDate};Label="Last Logon Date"}  | Format-Table -AutoSize
    
}else{
    
#   Write-Host "There are no locked out accounts on your local Domain Controller."

}

Write-Host ""


######################################
##   Ask for Username and Validate  ##
######################################


#Asks for the username
$user = Read-Host "Enter username of the employee you would like to check or [ Ctrl+c ] to exit"


[int]$Checker1 = 0

# ERROR CHECKING
Do {
    
    # Try to retrieve info for given user, catch error if unalbe to retrieve
    Try {

        # Attempt to retrieve info about user and suppress output
        Get-ADUser -Identity $user | Out-Null

        # If successful, set Checker to 1 to exi do loop.
        $Checker1 = 1

    }catch{
        
        # If Attempt to retrieve info fails, run code in this catch block
              
        #Username entered was not found.  Have user try again.
        cls
        Write-Host ""
        Write-Host ""
        Write-Host "Username not found! - Please try again." -BackgroundColor Red -ForegroundColor White
        Write-Host ""
        $user = Read-Host "Enter username of the employee you would like to check or [ Ctrl+c ] to exit"

    }
# If Checker1 is equal to zero, then redo Do loop.
}While ($Checker1 -eq 0)




#############################################################
##   Get and display user's Display Name and Phone Number  ##
#############################################################

#Once a valid user is entered, proceed with remaining code
cls 

Write-Host ""
Write-Host ""

# Gets Display name of entered user
$Name = (Get-ADUser -Filter {samAccountName -eq $user } -Properties * | Select-Object -expand DisplayName)

# Gets Phone number of entered user
$phone = (Get-ADUser -Filter {samAccountName -eq $user } -Properties * | Select-Object -expand telephoneNumber)

# Displays the Display Name and Phone number of user - I use this to verify I have the correct user and
# to have the phone number available, if I need to contact the user.
Write-Host "$Name's phone number is:  $phone"


Write-Host ""
Write-Host ""





####################################
##   Get and Check Password Age   ##
####################################

# Get today's date
[datetime]$today = (get-date)

#Get pwdlastset date from AD and set it to $passdate2
$passdate2 = [datetime]::fromfiletime((Get-ADUser -Filter {samAccountName -eq $user } -Properties * | 
    Select-Object -expand pwdlastset))

#calculate Password age in days
$PwdAge = ($today - $passdate2).Days

#check if  password is over 90 days old
If ($PwdAge -gt 90){
        
        # If password is over 90 days old, let admin know it is expired and show password age
        Write-Host "Password for $user is EXPIRED!"
        Write-Host "Password for $user is  $PwdAge days old."

}else{
        
        # If password is under 90, just display age
        Write-Host "Password for $user is $PwdAge days old."

}

Write-Host ""
Write-Host ""




########################################################
##   user Lockedout status on each available server   ##
########################################################

#Get Check server availablity, then check user Lockedout status on each available server
foreach ($object in $servers) {

    # ERROR CHECKING
    Try{
        
        # Check to see if server is available via a ping
        ping $object -n 1 | Out-Null

        # If server is available, complete code:
        switch (Get-ADUser -server $object -Filter {samAccountName -eq $user } -Properties * | 
            Select-Object -expand lockedout) { 
    
                "False" {"$object `t `t Not Locked"} 
        
                "True" {"$object `t `t LOCKED"}
   
        }

    }catch{
        
        # If server is not available, alert admin that it will be skipped.
        Write-host "$object `t `t NOT Found - Skipping" -ForegroundColor white -BackgroundColor red

        # Add unavailible server to $unavailible array
        $unavailable.add($object) | out-null
        
    }

}


################################
##   $servers Array Cleanup   ##
################################

<# 
    
    For each server that is unavailible, remove from $servers array

    The reason for this is so the unlockAndCheck & the resetPass function
    do not try to exicute thier code on the servers that are not 
    available. A little bit of error handling.

#>
foreach ($server in $unavailable){

    $servers.Remove($server)

}




##############################################
##   Ask Admin what they would like to do   ##
##############################################

Write-Host ""
Write-Host ""


$option = Read-Host  "Would you like to (1) Unlock user, (2) Reset user's password, `
    (3) Unlock and reset user's password or (4) Exit?"



################################
##   Carryout Selected Task   ##
################################
    
cls

[int]$checker2 = 0

While ($checker2 -eq 0) {
    
    switch ($option){
            
        "1" { 

                #Call unlockAndCheck Function
                unlockAndCheck
                                
                Write-Host ""
                Write-Host "Press any key to Exit."
                
                $checker2 += 5
                
                $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                
            
            }
        "2" { 
                
                #call resetPass function
                resetPass              
                           
                Write-Host ""
                Write-Host "Press any key to Exit."
                $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                
                $checker2 += 5
    
            }
        "3" {
    
                #call resetPass function
                resetPass
                               
                #Call unlockAndCheck Function
                unlockAndCheck                
                
            
                Write-Host ""
                Write-Host "Press any key to Exit."

                
                $checker2 += 5
                
                $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
            }
        "4" {
    
                #exit code
                $checker2 += 5
    
             }    
     default {
                
                Write-Host ""
                Write-Host ""
                Write-Host "You have entered an incorrect number." -BackgroundColor Red -ForegroundColor White
                Write-Host ""
                $option = Read-Host  "Would you like to (1) Unlock user, (2) Reset user's password, (3) Unlock and reset user's password or (4) Exit?"
        
              }
    }

}







