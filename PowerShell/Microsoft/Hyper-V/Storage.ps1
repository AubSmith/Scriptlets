# Convert vmdk to vhdx
import-module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'
ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "C:\WindowsServer2008STD.vmdk" -DestinationLiteralPath "M:\WinServer2008Std\" -VhdType DynamicHardDisk -VhdFormat Vhdx
