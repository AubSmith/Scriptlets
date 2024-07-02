<#
SYNTAX
    Test-NetConnection [[-ComputerName] <string>] [-TraceRoute] [-Hops <int>] [-InformationLevel {Quiet | Detailed}] [<CommonParameters>]
    
    Test-NetConnection [[-ComputerName] <string>] [-CommonTCPPort] {HTTP | RDP | SMB | WINRM} [-InformationLevel {Quiet | Detailed}] [<CommonParameters>]

    Test-NetConnection [[-ComputerName] <string>] -Port <int> [-InformationLevel {Quiet | Detailed}] [<CommonParameters>]

    Test-NetConnection [[-ComputerName] <string>] -DiagnoseRouting [-ConstrainSourceAddress <string>] [-ConstrainInterface <uint>] [-InformationLevel {Quiet | Detailed}] [<CommonParameters>]
#>

$ComputerName = 'LocalHost'
$Port = '25'
Test-NetConnection  -ComputerName $ComputerName -Port $Port # TNC
