<%
    Dim inputTemp As String
    Dim inputTempType As String
    Dim outputTemp As Integer
    Dim outputTempType As String
    If IsNothing(Request("temp")) Then
        inputTemp = ""
    Else
        inputTemp = CInt(Request("temp"))
    End If
    If IsNothing(Request("tempType")) Then
        inputTempType = ""
    Else
        inputTempType = Request("tempType")
    End If
    If inputTempType = "f2c" Then
        outputTemp = (inputTemp - 32) * (5 / 9)
        outputTempType = "C"
    End If
    If inputTempType = "c2f" Then
        outputTemp = inputTemp * (9 / 5) + 32
        outputTempType = "F"
    End If
    Dim str = "{ ""Temp"": """ & outputTemp & """, " & _
        " ""TempType"": """ & outputTempType & """ " & _
        "}"
    Response.Write(str)           
%>
