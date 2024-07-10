$users = Get-ADUser -Filter {Department -like "*licensing*"} -Properties Title, Department
$result = ForEach ($user in $users) {
    [PSCustomObject]@{
        Name = $user.Name
        Title = $user.Title
        Department = $user.name.Replace(" ", "")
    }
}

Write-Host $result