# View ACL
Get-Acl -Path D:\CertEnroll
(Get-Acl -Path D:\CertEnroll).Access
(Get-Acl -Path $dir).Access | Format-Table -AutoSize

(Get-Acl -Path $dir).Access | Where-Object {$_.IsInherited -eq $true} | Format-Table -AutoSize

(Get-Acl -Path $dir).Access | Where-Object {$_.IdentityReference -like 'USERNAME'} | Format-Table -AutoSize

# Set ACL
# Copy Client_list.txt Security Descriptors to Client_Projects.txt
$Acl = Get-Acl -Path 'C:\Share\Client_list.txt'
Set-Acl -AclObject $Acl -Path 'C:\Share\Client_Projects.txt'

Get-Acl -Path "C:\Dog.txt" | Set-Acl -Path "C:\Cat.txt"

# Create the ACE
$identity = 'domain\user'
$rights = 'FullControl' #Other options: [enum]::GetValues('System.Security.AccessControl.FileSystemRights')
$inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
$propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation, $type)

$Acl = Get-Acl -Path "$dir\Assets"
$Acl.AddAccessRule($ACE)

Set-Acl -Path "$dir\Assets" -AclObject $Acl

(Get-Acl -Path "$dir\Assets").Access | Format-Table -Autosize

# Remove ACL
$Acl = Get-Acl -Path "$dir\Client_Projects.txt"
$Ace = $Acl.Access | Where-Object {($_.IdentityReference -eq 'domain\user') -and -not ($_.IsInherited)}
$Acl.RemoveAccessRule($Ace)
Set-Acl -Path "$dir\Client_Projects.txt" -AclObject $Acl


<#
The list bellow shows what flags have to be set by creating of FileSystemAccessRule to establish wanted scenario.

Subfolders and Files only:
InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit
PropagationFlags.InheritOnly

This Folder, Subfolders and Files:
InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit
PropagationFlags.None

This Folder, Subfolders and Files:
InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit,
PropagationFlags.NoPropagateInherit

This folder and subfolders:
InheritanceFlags.ContainerInherit,
PropagationFlags.None

Subfolders only:
InheritanceFlags.ContainerInherit,
PropagationFlags.InheritOnly

This folder and files:
InheritanceFlags.ObjectInherit,
PropagationFlags.None

This folder and files:
InheritanceFlags.ObjectInherit,
PropagationFlags.NoPropagateInherit
#>