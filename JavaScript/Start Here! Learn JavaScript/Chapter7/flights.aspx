<%
    Dim str = "[ " & _
        "{ ""trip"": ""Around the block"", " & _
        " ""price"": 10000 " & _
        "}, " & _
        "{ ""trip"": ""Earth to Moon"", " & _
        " ""price"": 50000 " & _
        "}, " & _
        "{ ""trip"": ""Earth to Venus"", " & _
        " ""price"": 200000 " & _
        "}, " & _
        "{ ""trip"": ""Earth to Mars"", " & _
        " ""price"": 100000 " & _
        "}, " & _
         "{ ""trip"": ""Venus to Mars"", " & _
        " ""price"": 250000 " & _
        "}, " & _
        "{ ""trip"": ""Earth to Jupiter"", " & _
        " ""price"": 300000 " & _
        "}, " & _
        "{ ""trip"": ""Earth to Sun - One Way"", " & _
        " ""price"": 450000 " & _
        "}, " & _
        "{ ""trip"": ""Earth to Neptune"", " & _
        " ""price"": 475000 " & _
        "}, " & _
         "{ ""trip"": ""Earth to Uranus"", " & _
        " ""price"": 499000 " & _
        "} " & _
        "]"
    Response.Write(str)           
%>
