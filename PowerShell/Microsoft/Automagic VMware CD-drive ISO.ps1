<#
.SYNOPSIS
	This script creates an ISO file from an existing folder path.  It then copies this ISO file to the specified
	Vmware datastore and attaches it as a CD drive to a powered on VM.
.NOTES
	Created on: 	7/14/2014
	Created by: 	Adam Bertram
	Filename:	Copy-LocalPathToVmCdRom.ps1
	Credits:	http://gallery.technet.microsoft.com/scriptcenter/New-ISOFile-function-a8deeffd
	Requirements:	PowerCLI
	Todos:				
.EXAMPLE
	.\Copy-LocalPathToVmCdRom.ps1 -FolderPath C:\folder1 -VM VM1 -Datacenter 'Development' -Datastore 'datastore1' -DatastoreFolderPath 'DSFOLDER'
	This example would create an ISO file from the contents of C:\folder1, upload this ISO to the Development Vmware datacenter on the connected
	VI server, into the DSFOLDER on the datastore datastore1.
.PARAMETER FolderPath
 	The path to the folder you'd like to create an ISO file from the contents
.PARAMETER Vm
	The VM name you'd like to attach the ISO as a CD drive
.PARAMETER Datacenter
	The datacenter name that contains the datastore you'd like to upload the ISO file to
.PARAMETER Datastore
	The name of the datastore you'd like to put the ISO file in
.PARAMETER DatastoreFolderPath
	The name of the folder you'd like to place the ISO file in
	
#>
[CmdletBinding()]
param (
	[Parameter(Mandatory,
		ValueFromPipeline,
		ValueFromPipelineByPropertyName)]
	[ValidateScript({Test-Path $_ -PathType 'Container'})]
	[string]$FolderPath,
	[Parameter(Mandatory,
			   ValueFromPipeline,
			   ValueFromPipelineByPropertyName)]
	[string]$Vm,
	[Parameter(Mandatory,
			   ValueFromPipeline,
			   ValueFromPipelineByPropertyName)]
	[string]$Datacenter,
	[Parameter(Mandatory,
			   ValueFromPipeline,
			   ValueFromPipelineByPropertyName)]
	[string]$Datastore,
	[Parameter(Mandatory,
			   ValueFromPipeline,
			   ValueFromPipelineByPropertyName)]
	[string]$DatastoreFolderPath
)

begin {
	Set-StrictMode -Version Latest
	try {
		if (!(Get-PSSnapin 'VMware.VimAutomation.Core')) {
			throw 'PowerCLI snapin is not available'
		}
		$VmObject = Get-VM $Vm -ErrorAction SilentlyContinue
		if (!$VmObject) {
			throw "VM $Vm does not exist on connected VI server"
		}
		
		if ($VmObject.PowerState -ne 'PoweredOn') {
			throw "VM $Vm is not powered on. Cannot change CD-ROM IsoFilePath"
		}
		
		$TempIsoName = "$($Folderpath | Split-Path -Leaf).iso"
		$DatastoreIsoFolderPath = "vmstore:\$DataCenter\$Datastore\$DatastoreFolderPath"
		if (Test-Path "$DatastoreIsoFolderPath\$TempIsoName") {
			throw "ISO file $DatastoreIsoFolderPath\$TempIsoName already exists in datastore"
		}
		
		$ExistingCdRom = $VmObject | Get-CDDrive
		if (!$ExistingCdRom.ConnectionState.Connected) {
			throw 'No CD-ROM attached. VM is powered on so I cannot attach a new one'
		}
		
		## Hide the PowerCLI progres bars
		$ProgressPreference = 'SilentlyContinue'
		function New-IsoFile {
	  		<# 
		   .Synopsis 
		    Creates a new .iso file 
		   .Description 
		    The New-IsoFile cmdlet creates a new .iso file containing content from chosen folders 
		   .Example 
		    New-IsoFile "c:\tools","c:Downloads\utils" 
		    Description 
		    ----------- 
		    This command creates a .iso file in $env:temp folder (default location) that contains c:\tools and c:\downloads\utils folders. The folders themselves are added in the root of the .iso image. 
		   .Example 
		    dir c:\WinPE | New-IsoFile -Path c:\temp\WinPE.iso -BootFile etfsboot.com -Media DVDPLUSR -Title "WinPE" 
		    Description 
		    ----------- 
		    This command creates a bootable .iso file containing the content from c:\WinPE folder, but the folder itself isn't included. Boot file etfsboot.com can be found in Windows AIK. Refer to IMAPI_MEDIA_PHYSICAL_TYPE enumeration for possible media types: 
		 
		      http://msdn.microsoft.com/en-us/library/windows/desktop/aa366217(v=vs.85).aspx 
		   .Notes 
		    NAME:  New-IsoFile 
		    AUTHOR: Chris Wu 
		    LASTEDIT: 03/06/2012 14:06:16 
	 		#>
			Param (
				[parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]$Source,
				[parameter(Position = 1)][string]$Path = "$($env:temp)\" + (Get-Date).ToString("yyyyMMdd-HHmmss.ffff") + ".iso",
				[string] $BootFile = $null,
				[string] $Media = "Disk",
				[string] $Title = (Get-Date).ToString("yyyyMMdd-HHmmss.ffff"),
				[switch] $Force
			)#End Param
				
			Begin {
				($cp = new-object System.CodeDom.Compiler.CompilerParameters).CompilerOptions = "/unsafe"
				if (!("ISOFile" -as [type])) {
					Add-Type -CompilerParameters $cp -TypeDefinition @" 
						public class ISOFile 
						{ 
						    public unsafe static void Create(string Path, object Stream, int BlockSize, int TotalBlocks) 
						    { 
						        int bytes = 0; 
						        byte[] buf = new byte[BlockSize]; 
						        System.IntPtr ptr = (System.IntPtr)(&bytes); 
						        System.IO.FileStream o = System.IO.File.OpenWrite(Path); 
						        System.Runtime.InteropServices.ComTypes.IStream i = Stream as System.Runtime.InteropServices.ComTypes.IStream; 
						 
						        if (o == null) { return; } 
						        while (TotalBlocks-- > 0) { 
						            i.Read(buf, BlockSize, ptr); o.Write(buf, 0, bytes); 
						        } 
						        o.Flush(); o.Close(); 
						    } 
						} 
"@
				}#End If
					
				if ($BootFile -and (Test-Path $BootFile)) {
					($Stream = New-Object -ComObject ADODB.Stream).Open()
					$Stream.Type = 1  # adFileTypeBinary
					$Stream.LoadFromFile((Get-Item $BootFile).Fullname)
					($Boot = New-Object -ComObject IMAPI2FS.BootOptions).AssignBootImage($Stream)
				}#End If
				
				$MediaType = @{
					CDR = 2; CDRW = 3; DVDRAM = 5; DVDPLUSR = 6; DVDPLUSRW = 7; `
					DVDPLUSR_DUALLAYER = 8; DVDDASHR = 9; DVDDASHRW = 10; DVDDASHR_DUALLAYER = 11; `
					DISK = 12; DVDPLUSRW_DUALLAYER = 13; BDR = 18; BDRE = 19
				}
				
				if ($MediaType[$Media] -eq $null) { write-debug "Unsupported Media Type: $Media"; write-debug ("Choose one from: " + $MediaType.Keys); break }
				($Image = new-object -com IMAPI2FS.MsftFileSystemImage -Property @{ VolumeName = $Title }).ChooseImageDefaultsForMediaType($MediaType[$Media])
				
				if ((Test-Path $Path) -and (!$Force)) { "File Exists $Path"; break }
				New-Item -Path $Path -ItemType File -Force | Out-Null
				if (!(Test-Path $Path)) {
					"cannot create file $Path"
					break
				}
			}
			
			Process {
				switch ($Source) { { $_ -is [string] } { $Image.Root.AddTree((Get-Item $_).FullName, $true) | Out-Null; continue }
					{ $_ -is [IO.FileInfo] } { $Image.Root.AddTree($_.FullName, $true); continue }
					{ $_ -is [IO.DirectoryInfo] } { $Image.Root.AddTree($_.FullName, $true); continue }
				}#End switch
			}#End Process
			
			End {
				$Result = $Image.CreateResultImage()
				[ISOFile]::Create($Path, $Result.ImageStream, $Result.BlockSize, $Result.TotalBlocks)
				$Target
			}#End End
		}#End function New-IsoFile
		
		
	} catch {
		Write-Error $_.Exception.Message
		exit
	}
}

process {
	try {
		## Create an ISO
		$IsoFilePath = "$($env:TEMP)\$TempIsoName"
		Get-ChildItem $FolderPath | New-IsoFile -Path $IsoFilePath -Title ($Folderpath | Split-Path -Leaf) -Force		
		## Upload the ISO to the datastore
		$Iso = Copy-DatastoreItem $IsoFilePath "vmstore:\$Datacenter\$Datastore\$DatastoreFolderPath" -PassThru
		## Attach the ISO to the VM
		$VmObject | Get-CDDrive | Set-CDDrive -IsoPath $Iso.DatastoreFullPath -Connected $true -Confirm:$false | Out-Null
		## Delete the temp ISO
		Remove-Item $IsoFilePath -Force
	} catch {
		Write-Error $_.Exception.Message	
	}
}

end {
	try {
		
	} catch {
		Write-Error $_.Exception.Message
	}
}