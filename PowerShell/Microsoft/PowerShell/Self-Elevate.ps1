
# PowerShell demo to self-elevate a script
# - Makes sure parameters are properly forwarded to the elevated script (preserving argument types and spaces in string arguments).
# - Passes the current directory to elevated script.
param(
	[string] $Foo,
	[int] $Bar
)

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
	if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
		$argsSerialized = [Management.Automation.PSSerializer]::Serialize( $PSBoundParameters )
		$command = @"
Set-Location '$PWD'
`$theArgs = [Management.Automation.PSSerializer]::Deserialize(@'
$argsSerialized
'@)
& '$($MyInvocation.MyCommand.Path)' @theArgs  
"@
		$encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes( $command ))
		Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-EncodedCommand $encodedCommand"
		Exit
	}
}

"PWD: $pwd"
""
"Foo: $Foo [$($Foo.GetType().Name)]"
"Bar: $Bar [$($Bar.GetType().Name)]"
""
pause