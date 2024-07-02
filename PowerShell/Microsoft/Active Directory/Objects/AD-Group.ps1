Get-ADGroup -Filter {Name -like 'TFS*'} >> D:\TFS.log
Get-ADGroup -Filter {Name -like '*TFS*'} >> D:\TFS.log
Get-ADGroup -Filter {Name -like '*TFS'} >> D:\TFS.log
