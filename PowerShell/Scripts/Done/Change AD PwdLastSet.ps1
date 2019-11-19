###################################################################################################################################################
# ScriptName: Change_User_pwdlastset.ps1
# Version 1.0
# Requires PS v3.0
#  
# Script is specially build for VDI Environments with Windows 7 clients
#
# 
# Problem Case:
# =============
#
# When a user is logged in his desktop and he is away from his desktop and the screen is locked.
# In the meantime the password expires and user wants to login again, Windows 7 is telling you to change your password.
# To change the password a user have to click 'Switch User'. When he does the RDP connection is closed, the user is returning to
# the Webportal to login again. Very confusing and time consuming for the user.
#
# 
# Problem Solution:
# =================
# 
# To solve the irritating situation I created this script to change the 'Password last change' to the night (in my example to 23:00h)
# for all users who changed their password during the last x hours (for me 23). Most of the users login during daylight hours.
# When users login in the morning, they directly get an Password Expiration warning to change their password and not during the day
# on an unappropriate time.
#
# The script is not changing the real expire date/time, but it is change the Last Password (AD User Property 'PwdLastSet').
# This property will be set to the current date and time, so when the script is run.
# PwdLastSet + PasswordPolicy = Password Expiration
#
# 
# Example user:
# =============
# 
# Password policy for this user is: change password policy every 100 days
#
# - 08:15h : UserA logs in to his desktop and get the message to change his password.
#            The user is changing his password and works all day without problems.
# - 23:00h : This script is running and is checking which users changed their password for the last 23 hours.
#            The script will change for all these users their 'PwdLastSet' attribute to the current date and time
# 
# - 100 days later at 23:00h the password for UserA will expire
# - The next morning when UserA comes in the building he gets prompt to change his password again.
#
#
#
#
###################################################################################################################################################


########################################################################
# Setting variables you have to fill in for your environment
########################################################################
$logfile = #fill in your logfile locationpath
$DN_OU_Path = #fill in your distinguishedName OU path where the effected users exist. For example: CN=Users,DC=Contoso,DC=local
$hourschange_sincePwdChange = #fill in the number of hours since the user change his password. For example: 23 (When you run the script on 23:00h)


########################################################################
# Create LogFile
########################################################################
$logdate = Get-Date -format yyyyMMdd
Add-Content $logile_$logdate.log "samaccountname, lastchange, today, hoursdiff"


########################################################################
# Set scope for effected users
########################################################################
Get-ADUser -Filter * -SearchScope Subtree -SearchBase "$DN_OU_Path" -Properties Name,pwdLastSet | select SamAccountName,pwdLastSet |


########################################################################
# Start the real thing
########################################################################
ForEach-Object {
  $samaccountname = $_.SamAccountName
  $today = Get-Date
  
  # Convert the Date in a good Format
  $lastchange = [datetime]::FromFileTime($_.pwdlastset[0]) # Convert the Date in a good Format

  # Get the timedifference between last password change and the current date/time
  $timediff = New-TimeSpan $lastchange $(Get-Date)
  
  # Convert to difference in hours
  $hoursdiff = $timediff.TotalHours

  if ($hoursdiff -lt $hourschange_sincePwdChange) {
    $todouser = Get-ADUser $samaccountname -Properties pwdLastSet
    
    # First change the pwdlastset to 0 because Microsoft wants it this way
    $todouser.pwdLastSet = 0
    Set-ADUser -Instance $todouser
    
    # Change the pwdlastset to the current date/time of the associate DC
    $todouser.pwdLastSet = -1
    Set-ADUser -Instance $todouser

    # Filling the logfile
    Add-Content $logfile_$logdate.log "$samaccountname, $lastchange, $today, $hoursdiff"
  }

}

########################################################################
# The END
########################################################################