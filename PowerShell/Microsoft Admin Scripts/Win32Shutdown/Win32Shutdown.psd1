@{
    GUID = '80fc7075-ca45-4b12-a4a7-d7a43fdd91c4'
    Author='Chris Carter'
    CompanyName='N/A'
    Copyright='© 2016 Chris Carter. All rights reserved.'
    Description='The Win32Shutdown PowerShell module contains commands to log off, reboot, and shutdown local and remote computers. See about_Win32Shutdown for more information.'
    ModuleVersion = '0.9.0.0'
    PowerShellVersion = '3.0'
    NestedModules = @('Win32Shutdown.cdxml')
    #AliasesToExport = '*'
    FunctionsToExport = @('Get-OperatingSystem','Start-Shutdown','Start-TrackedShutdown','Start-PowerOff','Start-Reboot')
    PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('CIM','WMI','Win32','Shutdown','Reboot','LogOff','Win32_OperatingSystem','Win32Shutdown')

        # A URL to the license for this module.
        LicenseUri = 'http://creativecommons.org/licenses/by-sa/4.0/'

        # A URL to the main website for this project.
        ProjectUri = 'https://gallery.technet.microsoft.com/Log-Off-Reboot-or-Shutdown-5cbff051'

        # ReleaseNotes of this module
        ReleaseNotes = "This is being released as a late beta. Everything functions correctly, and all the help is completed. However, the command names are still being debated, and may change at any time before version 1.0. Any ideas would be welcomed."

    } # End of PSData hashtable

} # End of PrivateData hashtable
    HelpInfoUri='http://medbill.co/powershell/updateable-help'
}