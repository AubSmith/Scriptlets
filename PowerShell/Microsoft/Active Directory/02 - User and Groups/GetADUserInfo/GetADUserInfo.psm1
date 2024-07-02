#--------------------------------------------------------------------------------- 
#The sample scripts are not supported under any Microsoft standard support 
#program or service. The sample scripts are provided AS IS without warranty  
#of any kind. Microsoft further disclaims all implied warranties including,  
#without limitation, any implied warranties of merchantability or of fitness for 
#a particular purpose. The entire risk arising out of the use or performance of  
#the sample scripts and documentation remains with you. In no event shall 
#Microsoft, its authors, or anyone else involved in the creation, production, or 
#delivery of the scripts be liable for any damages whatsoever (including, 
#without limitation, damages for loss of business profits, business interruption, 
#loss of business information, or other pecuniary loss) arising out of the use 
#of or inability to use the sample scripts or documentation, even if Microsoft 
#has been advised of the possibility of such damages 
#--------------------------------------------------------------------------------- 

#requires -Version 2.0

Import-Module ActiveDirectory
Function Get-OSCSamAccountName
{
<#
 	.SYNOPSIS
        Get-OSCSamAccountName is an advanced function which can be used to get active directory user SamAccount name.
    .DESCRIPTION
        Get-OSCSamAccountName is an advanced function which can be used to get active directory user SamAccount name.
    .PARAMETER  CsvFilePath
		Specifies the path you want to import csv files.
    .EXAMPLE
        C:\PS> Get-OSCSamAccountName -CsvFilePath C:\Script\Users.csv

		This command will list all active directory user SamAccount Name info.
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [String]$CsvFilePath
    )

    If($CsvFilePath)
    {
        If(Test-Path -Path $CsvFilePath)
        {
            #import the csv file and store in a variable
            $Names = (Import-Csv -Path $CsvFilePath).DisplayName
            
            Foreach($Name in $Names)
            {
                $Name = $Name.Replace(" ","") -split ","
                $FirstName = $Name[0].Trim()
                $LastName = $Name[1].Trim()
                $UserName = $FirstName + " " + $LastName
                #Retrieve the ad users based on previous two variables.
                $SamAccountName = Get-ADUser -Filter{ Surname -eq $LastName -and GivenName -eq $FirstName}|`
                Select -ExpandProperty SamAccountName
                
                If($SamAccountName -eq $null)
                {
                    $SamAccountName = "NotFound"
                }

                #Output the result
                New-Object -TypeName PSObject -Property @{DisplayName = $UserName
                                                          SamAccountName = $SamAccountName
                                                         }
                    
            }
        }
        Else
        {
            Write-Warning "Cannot find path '$CsvFilePath' because it does not exist."
        }
    }
}