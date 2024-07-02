
Write-Host "Starting..."

# Set ErrorActionPreference to "Stop"
$ErrorActionPreference = "Stop"


function Set-Files {
    Try {
        if ($null -eq $File_List){

            Write-Host "Nothing to do..."

            Continue
        }
        else {

            Write-Host "In function..."

            $Files = $File_List.Name

            foreach ($File in $Files){
                Copy-Item "$SourceDir\$File" $DestinationDir

                $Archive = "$DestinationDir2" + $(Get-Date).ToString('yyyy_MMMM')

                    if (!(Test-Path $Archive)){
                        New-Item $Archive -ItemType Directory
                    }

                    Move-Item "$SourceDir\$File" $Archive
            }
        }
    }

    catch {
        
        Write-Host "An error occurred:" $_.Exception.Message
        Write-Host $_.ScriptStackTrace

        exit(1)
    }
}


$File_List = Get-ChildItem -Path $SourceDir | Where-Object {($_.Name -like 'file*.txt' -or $_.Name -like 'file*.csv')}

$SourceDir = 'E:\Code\PowerShell'
$DestinationDir = 'E:\Code\PowerShell\Temp\'
$DestinationDir2 = 'E:\Test\'


Write-Host "Calling function..."

Set-Files



$File_List = Get-ChildItem -Path $SourceDir | Where-Object {($_.Name -like 'Test*.csv' -or $_.Name -like 'Test*.txt')}

$SourceDir = 'E:\Code\PowerShell'
$DestinationDir = 'E:\Code\PowerShell\Temp2\'
$DestinationDir2 = 'E:\Test2\'


Write-Host "Calling function... again..."

Set-Files

Exit $LASTEXITCODE
