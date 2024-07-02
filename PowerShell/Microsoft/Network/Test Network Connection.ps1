# Test ping connectivity
tnc github.com -port 443

# Test ping connectivity
tnc github.com -CommonTCPPort http

# Test ping connectivity with detailed results
Test-NetConnection -InformationLevel "Detailed"

# Test TCP connectivity and display detailed results
Test-NetConnection -Port 80 -InformationLevel "Detailed"

# Test a connection to a remote host
Test-NetConnection -ComputerName "www.contoso.com" -InformationLevel "Detailed"

# Perform route diagnostics to connect to a remote host
Test-NetConnection -ComputerName www.contoso.com -DiagnoseRouting -InformationLevel Detailed

# Perform route diagnostics to connect to a remote host with routing constraints
Test-NetConnection -ComputerName "www.contoso.com" -ConstrainInterface 5 -DiagnoseRouting -InformationLevel "Detailed"
