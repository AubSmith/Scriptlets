# SQL Compare Script

## Requirements
- Install [SqlServer PowerShell](https://www.powershellgallery.com/packages/Sqlserver/22.2.0) module
  
  It can be installed by running the following command:
  ```Install-Module -Name SqlServer -RequiredVersion 22.2.0```

- The module needs to be installed to -"C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules\SqlServer-
  If the path is not accessible due to insufficient privileges, then install the module to -"%USERPROFILE%\Documents\WindowsPowerShell\Modules"-
  
  Path can be updated using the following command:
  ```$env:PSModulePath = $env:PSModulePath + ";C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules" ```

- If need be, set the script execution policy for the current PowerShell session with the following command:
  ```Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned```

## Script Execution
