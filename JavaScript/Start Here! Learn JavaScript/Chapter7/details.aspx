<%
    Dim flightID As String
    Dim outputStr As String
    If IsNothing(Request("flightID")) Then
        flightID = "Unknown"
    Else
        flightID = Request("flightID")
    End If
    If flightID = "flight0" Then
        outputStr = "1 minute"
    ElseIf flightID = "flight1" Then
        outputStr = "5 Days"
    ElseIf flightID = "flight2" Then
        outputStr = "7 Days"
    ElseIf flightID = "flight3" Then
        outputStr = "8 Days"
    ElseIf flightID = "flight4" Then
        outputStr = "9 Days"
    ElseIf flightID = "flight5" Then
        outputStr = "12 Days"
    Else
        outputStr = "15 Days"
    End If
    
    Dim str = "{ ""duration"": """ & outputStr & """ }"
    Response.Write(str)
%>
