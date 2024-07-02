$user = "domain\user"
$Folders = Get-childItem c:\TEMP\
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$objType = [System.Security.AccessControl.AccessControlType]::Allow 

$Folders | %{
    $Folder = $_

    $acl = Get-Acl $Folder
    $permission = $user,"Modify", $InheritanceFlag, $PropagationFlag, $objType
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission

    $acl.SetAccessRule($accessRule)
    Set-Acl $Folder $acl
} 