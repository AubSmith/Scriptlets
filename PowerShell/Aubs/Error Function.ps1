Function Reset-Error {
    $Global:Error.Clear()
    $psISE.Options.ErrorForegroundColor = '#FFFF0000'
    $global:ErrorView = 'NormalView'
}
Reset-Error

# Generate an Error

Function Show-Error {Get-Item C:\doesNotExist.txt}
Show-Error