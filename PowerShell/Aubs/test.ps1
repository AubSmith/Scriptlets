# q: write a function that connects to a remote server and returns the output of a command
function Invoke-RemoteCommand {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Server,

        [Parameter(Mandatory = $true)]
        [string]$Username,

        [Parameter(Mandatory = $true)]
        [SecureString]$Password,

        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    $securePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $securePassword

    try {
        $session = New-PSSession -ComputerName $Server -Credential $credential
        $output = Invoke-Command -Session $session -ScriptBlock { param($cmd) Invoke-Expression $cmd } -ArgumentList $Command
        Remove-PSSession -Session $session
        return $output
    }
    catch {
        Write-Error "Failed to connect to the remote server: $_"
    }
}
