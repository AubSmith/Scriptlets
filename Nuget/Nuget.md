# Nuget

Nuget is a packaged zip archive. This is the process to install packages manually when Nuget CLI is not available:
- Rename package from .nuget to .zip
- Delete the four following items from the extracted folder
    - _rels
    - package
    - [Content_Types].xml
    - .nuspec


## Nuget CLI update
```nuget update -self```


## Create spec
nuget spec


## Create package


## List local global package location
```nuget.exe locals -list global-packages```


## PowerShell Modules

Run ```Write-Output $env:PSModulePath``` to determine the locations to place the extracted PowerShell modules. Copy the extracted module directory to one of these locations.
