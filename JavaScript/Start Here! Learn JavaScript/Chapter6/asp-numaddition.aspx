<%
    Dim num1 As String
    Dim num2 As String
    If IsNothing(Request.QueryString("num1")) Then
        num1 = ""
    Else
        num1 = Request.QueryString("num1")
    End If
    If IsNothing(Request.QueryString("num2")) Then
        num2 = ""
    Else
        num2 = Request.QueryString("num2")
    End If
    If (IsNumeric(num1) And IsNumeric(num2)) Then
        Response.Write(CInt(num1) + CInt(num2))
    End If
%>
