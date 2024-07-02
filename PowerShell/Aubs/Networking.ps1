Test-NetConnection www.google.com -TraceRoute
Test-NetConnection www.google.com -TraceRoute -Hops 20
Test-NetConnection www.google.com -TraceRoute -InformationLevel "Detailed"

Test-NetConnection -InformationLevel "Detailed"
Test-NetConnection -Port 80 -InformationLevel "Detailed"
Test-NetConnection -ComputerName "www.google.com" -InformationLevel "Detailed"
Test-NetConnection -ComputerName www.google.com -DiagnoseRouting -InformationLevel Detailed
