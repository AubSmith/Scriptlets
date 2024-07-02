# Force TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

<##########
PackageManagement is;
- a package delivery framework in Windows
- administered through PowerShell, but applies to the whole operating system or user profile

It provides two main classes:
1) A PackageProvider - is the equivalent of a package manager; YUM, Homebrew, Chocolatey/NuGet.
2) A PackageSource serves a single PackageProvider and is where the provider gets its packages from.
##########>

Get-PackageProvider
Get-PackageSource

Register-PackageSource -Name Artifactory -Location https://artifactory.url/artifactory/api/nuget/$reponame -ProviderName Artifactory # Register
Unregister-PackageSource -Source MyNuGet # Unregister

Find-PackageProvider
Find-PackageProvider -Name "Nuget" -AllVersions
Find-PackageProvider -Name "Gistprovider" -Source "PSGallery"

Get-Package # Locally installed packages
Invoke-Command -ComputerName Server01 -Credential CONTOSO\TestUser -ScriptBlock {Get-Package} # Packages installed remote system
Get-Package -ProviderName PowerShellGet -AllVersions # Installed packages from specific provider
Get-Package -Name posh-git -RequiredVersion 0.7.3 | Uninstall-Package # Uninstall package

Find-Package -ProviderName NuGet
Find-Package -Name "JiraPS"
Find-Package -Name "VMWare*"
Find-Package -Name "VMWare*" -AllVersions
Find-Package -Name NuGet.Core -Source MyNuGet
Find-Package -Name NuGet.Core -Source MyNuGet -AllVersions
Find-Package -Name NuGet.Core -ProviderName NuGet -RequiredVersion 2.9.0
Find-Package -Name NuGet.Core -ProviderName NuGet -MinimumVersion 2.7.0 -MaximumVersion 2.9.0 -AllVersions
Find-Package -Source C:\LocalPkg
Find-Package -Name NuGet.Core -Source MyNuGet | Install-Package

Install-Package -Name NuGet.Core -Source MyNuGet -MinimumVersion 2.8.0 -MaximumVersion 2.9.0
Install-Package -Name NuGet.Core -Source MyNuGet -Credential Contoso\TestUser

# Install a specified version of a package provider
Find-PackageProvider -Name "NuGet" -AllVersions
Install-PackageProvider -Name "NuGet" -RequiredVersion "2.8.5.216" -Force

Find-PackageProvider -Name "GistProvider" | Install-PackageProvider -Verbose # Find a provider and install it

Install-PackageProvider -Name GistProvider -Verbose -Scope CurrentUser # Install a provider to the current user's module folder

Uninstall-Package -Name NuGet.Core
Get-Package -Name NuGet.Core -RequiredVersion 2.14.0 | Uninstall-Package
