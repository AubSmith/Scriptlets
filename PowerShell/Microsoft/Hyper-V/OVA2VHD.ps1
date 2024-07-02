<#
#  Name: New-ActiveClusterMediatorVM.ps1
#  Version: 0.5
#  Purpose: Convert VMware OVA to Hyper-V VHD.
#  Requires -Version 5
#>

Clear-Host

# Set default variables
$ACMDirectory = "D:\ACM"
$VMName = "AC-MediatorTest"
$HyperVHost = "localhost"
$OVAName = "<NAME>.ova"
$SourceOVAPath = "$ACMDirectory\$OVAName"
$DestinationVHDPath = "$ACMDirectory\$VMName.vhd"
$vSwitchName = "vSwitch"


# Import the Microsoft VM Converter Powershell Module.
# Install from https://www.microsoft.com/en-us/download/details.aspx?id=42497
Import-Module "C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1"
Import-Module -Name 7Zip4Powershell

 
# Unzip the <Name>.ova file to specified directory. An OVA is just a ZIP (TAR) file containing contents.
Copy-Item -Path $SourceOVAPath -Destination "$ACMDirectory\$VMName.zip"
Expand-7Zip -ArchiveFileName "$SourceOVAPath" -TargetPath "$ACMDirectory\$VMName"

 
# Find VMDK to convert to VHD.
$VMDKName = (Get-ChildItem -Path "$ACMDirectory\$VMName" -Filter *.vmdk).Name
$SourceVMDKPath = "$ACMDirectory\$VMName\$VMDKName"

 
# Convert the .VMDK from the OVA to a Virtual Hard Disk (VHD) - Generation 1.
# To understand Gen1 vs Gen2 read https://technet.microsoft.com/en-us/library/dn440675%28v=sc.12%29.aspx?f=255&MSPPError=-2147217396
ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath $SourceVMDKPath -DestinationLiteralPath $DestinationVHDPath -VhdType FixedHardDisk -VhdFormat Vhd

 
# Create new virtual machine with specified parameters.
New-VM -Name $VMName -MemoryStartupBytes 8GB -VHDPath $DestinationVHDPath -Generation 1 -SwitchName $vSwitchName | Set-VM -ProcessorCount 2 -Passthru | Start-VM