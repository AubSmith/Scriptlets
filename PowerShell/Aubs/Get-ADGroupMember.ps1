try {
    
    # Function Get-ADGroupMember that takes a group name as a parameter and returns a list of all members of that group.
    function Get-ADGroupMember {
        param (
            [Parameter(Mandatory=$true)]
            [string]$GroupName
        )

        $members = Get-ADGroupMember -Identity $GroupName | Select-Object Name, SamAccountName

        return $members
    }
} catch {
    Write-Error "An error occurred: $_"
}
