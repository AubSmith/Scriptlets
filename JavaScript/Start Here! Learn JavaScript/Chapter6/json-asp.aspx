<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm1.aspx.vb"
Inherits="StartHere.WebForm1" %>
<%@ Import Namespace="System.Web.Script.Serialization" %> 
<% 
       Dim Colors(4) As String
       Colors(0) = "Red"
       Colors(1) = "Blue"
       Colors(2) = "Green"
       Colors(3) = "Orange"
       Colors(4) = "Yellow"
       Dim serializer As New JavaScriptSerializer()
       Dim arrayJson As String = serializer.Serialize(Colors)
       Response.Write(arrayJson)    
%>
