#@=============================================
#@ FileName: SystemInfo_(Excel).ps1
#@=============================================
#@ Script Name: SystemInfo_(Excel)
#@ Created: [DATE_DMY] 20/03/2013
#@ Author: Amol Patil
#@ Email: amolsptech@gmail.com
#@ Web: 
#@ Requirements:
#@ OS: 
#@ Keywords:
#@ Version History:
#@=============================================
#@ Purpose:
#@ To collect System Information local/remote
#@
#@=============================================

#@================Code Start===================

# ==============================================================================================
# Function SysInfo - collects information using WMI and places results in Excel Sheet
# ==============================================================================================
Function SysInfo {

    foreach ($StrComputer in $colComputers){

$GenItems1 = gwmi Win32_ComputerSystem -Comp $StrComputer 
$GenItems2 = gwmi Win32_OperatingSystem -Comp $StrComputer 
$SysItems3 = gwmi Win32_WmiSetting -Comp $StrComputer 
$MemItems1 = gwmi Win32_PhysicalMemory -Comp $StrComputer 
$MemItems2 = gwmi Win32_PhysicalMemoryArray -Comp $StrComputer 
$NetItems = gwmi Win32_NetworkAdapterConfiguration -Comp $StrComputer  | where{$_.IPEnabled -eq "True" -and $_.DNSHostName -ne $NULL}

# Populate General Sheet(1) with information

foreach ($objItem in $GenItems1){

    #$Sheet1.Cells.Item($intRow, 1) = $StrComputer
    $Sheet1.Cells.Item($intRow, 1) = $objItem.Name
    $Sheet1.Cells.Item($intRow, 2) = $objItem.Domain
    $Sheet1.Cells.Item($intRow, 3) = $objItem.Manufacturer
    $Sheet1.Cells.Item($intRow, 4) = $objItem.Model
    $Sheet1.Cells.Item($intRow, 5) = $objItem.SystemType
    $Sheet1.Cells.Item($intRow, 6) = $objItem.TotalPhysicalMemory / 1024 / 1024
    
        }

foreach ($objItem in $GenItems2){

    $Sheet1.Cells.Item($intRow, 7) = $objItem.Caption
    $Sheet1.Cells.Item($intRow, 8) = $objItem.BuildNumber
    $Sheet1.Cells.Item($intRow, 9) = $objItem.CSDVersion
    $Sheet1.Cells.Item($intRow, 10) = $objItem.Version
    $Sheet1.Cells.Item($intRow, 11) = $objItem.OSArchitecture

        }

foreach ($objItem in $NetItems){

    $Sheet1.Cells.Item($intRowNet, 12) = $objItem.IPAddress

        }       

$intRow = $intRow + 1
$intRowNet = $intRowNet + 1

}

}

#@=============================================

# ========================================================================

# Function Name 'HostList' - Enumerates Computer Names in a text file

# Create a text file and enter the names of each computer. One computer

# name per line. Supply the path to the text file when prompted.

# ========================================================================

Function HostList {
$strText = Read-Host "Enter the path for the text file"
$colComputers = Get-Content $strText
}

# ========================================================================

# Function Name 'Host' - Enumerates Computer from user input

# ========================================================================

Function Host {

            $colComputers = Read-Host "Enter Computer Name or IP"

}
# ========================================================================

# Function Name 'LocalHost' - Enumerates Computer from user input

# ========================================================================

Function LocalHost {

            $colComputers = $env:computername

}

#@=================================================================================================================================
#Gather info from user input.

Write-Host "********************************"               -ForegroundColor Green
Write-Host "System Information Inventory"                   -ForegroundColor Green
Write-Host "by: Amol Patil "                                -ForegroundColor Green
Write-Host "********************************"               -ForegroundColor Green
Write-Host " "

Write-Host "Which computer resources would you like in the report?"   -ForegroundColor Green

$strResponse = Read-Host "
[1] Computer Names from a File.
[2] Enter a Computer Name manually.
------OR------
[3] Local Computer.

"

            If($strResponse -eq "1"){. HostList}
                elseif($strResponse -eq "2"){. Host}
                elseif($strResponse -eq "3"){. LocalHost}
                else{Write-Host "You did not supply a correct response, `

                Please run script again." -foregroundColor Red}                                                                

Write-Progress -Activity "Getting Inventory" -status "Running..." -id 1
#@=================================================================================================================================

#New Excel Application

$Excel = New-Object -Com Excel.Application

$Excel.visible = $True

# Create 2 worksheets

$Excel = $Excel.Workbooks.Add()

# Assign each worksheet to a variable and

# name the worksheet.

$Sheet1 = $Excel.Worksheets.Item(1)

$Sheet2 = $Excel.WorkSheets.Item(2)

$Sheet1.Name = "SysInfo"

$Sheet2.Name = "Software"

#Create Heading for General Sheet

$Sheet1.Cells.Item(1,1) = "Name"
$Sheet1.Cells.Item(1,2) = "Domain"
$Sheet1.Cells.Item(1,3) = "Manufacturer"
$Sheet1.Cells.Item(1,4) = "Model"
$Sheet1.Cells.Item(1,5) = "SystemType"
$Sheet1.Cells.Item(1,6) = "Memory"
$Sheet1.Cells.Item(1,7) = "Operating_System"
$Sheet1.Cells.Item(1,8) = "BuildNumber"
$Sheet1.Cells.Item(1,9) = "ServicePack"
$Sheet1.Cells.Item(1,10) = "Version"
$Sheet1.Cells.Item(1,11) = "OSArchitecture"
$Sheet1.Cells.Item(1,12) = "IPAddress"


$colSheets = ($Sheet1, $Sheet2)

foreach ($colorItem in $colSheets){

$intRow = 2

$intRowDisk = 2

$intRowSoft = 2

$intRowNet = 2

$WorkBook = $colorItem.UsedRange

$WorkBook.Interior.ColorIndex = 40

$WorkBook.Font.ColorIndex = 11

$WorkBook.Font.Bold = $True

}



If($credResponse -eq "y"){SysInfoCrd}

Else{SysInfo}



#Auto Fit all sheets in the Workbook

foreach ($colorItem in $colSheets){

$WorkBook = $colorItem.UsedRange                                                                                                                                                                                                                                    

$WorkBook.EntireColumn.AutoFit()

#clear

}

Write-Host "@*******************************@" -ForegroundColor Green

Write-Host "The Report has been completed."  -ForeGroundColor Green

Write-Host "@*******************************@" -ForegroundColor Green

#@================Code End=====================
