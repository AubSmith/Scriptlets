<#PSScriptInfo
.VERSION 1.0.1
.GUID 2ada2ead-8736-4d5e-9587-e14bacc28761
.AUTHOR DSC Community
.COMPANYNAME DSC Community
.COPYRIGHT DSC Community contributors. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/dsccommunity/ActiveDirectoryDsc/blob/main/LICENSE
.PROJECTURI https://github.com/dsccommunity/ActiveDirectoryDsc
.ICONURI https://dsccommunity.org/images/DSC_Logo_300p.png
.RELEASENOTES
Updated author, copyright notice, and URLs.
#>

#Requires -Module ActiveDirectoryDsc

<#
    .DESCRIPTION
        This configuration will wait for an Active Directory domain controller
        to respond within 300 seconds (default) in the domain 'contoso.com'
        before returning and allowing the configuration to continue to run.
        If the timeout is reached the node will be restarted up to two times
        and again wait after each restart. If no domain controller is found
        after the second restart an error will be thrown.
        This will use the user credential passed in the built-in PsDscRunAsCredential
        parameter when determining if the domain is available.
#>
Configuration WaitForADDomain_WaitForDomainControllerWithReboot_Config
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {
        WaitForADDomain 'contoso.com'
        {
            DomainName           = 'contoso.com'
            RestartCount         = 2

            PsDscRunAsCredential = $Credential
        }
    }
}
