﻿function Set-PowerShellWindowTitle
{
<#
    .SYNOPSIS
        Function to set the title of the PowerShell Window

    .DESCRIPTION
        Function to set the title of the PowerShell Window

    .PARAMETER Title
        Specifies the Title of the PowerShell Window

    .EXAMPLE
        PS C:\> Set-PowerShellWindowTitle -Title LazyWinAdmin.com

    .NOTES
        Francois-Xavier Cat
        lazywinadmin.com
        @lazywinadmin
#>
    PARAM($Title)
    $Host.UI.RawUI.WindowTitle = $Title
}

