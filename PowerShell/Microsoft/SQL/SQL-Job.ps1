# Set the necessary variables
$Server = "YOUR_SERVER_NAME"
$Database = "YOUR_DATABASE_NAME"
$Query = "YOUR_SQL_QUERY"
$AttachmentPath = "C:\Path\To\Attachment.csv"
$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587
$EmailFrom = "youremail@gmail.com"
$EmailTo = "recipient@example.com"
$EmailSubject = "SQL Query Results"
$EmailBody = "Please find the attached SQL query results."

# Load the necessary assemblies
[System.Reflection.Assembly]::LoadWithPartialName("System.Data") | Out-Null

# Create a new SqlConnection object
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$Server;Database=$Database;Integrated Security=True"

# Create a new SqlCommand object
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $Query
$SqlCmd.Connection = $SqlConnection

# Create a new SqlDataAdapter object
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd

# Create a new DataTable object
$DataTable = New-Object System.Data.DataTable

# Fill the DataTable with the results of the SQL query
$SqlAdapter.Fill($DataTable) | Out-Null

# Export the DataTable to a CSV file
$DataTable | Export-Csv $AttachmentPath -NoTypeInformation

# Create a new MailMessage object
$MailMessage = New-Object System.Net.Mail.MailMessage
$MailMessage.From = $EmailFrom
$MailMessage.To.Add($EmailTo)
$MailMessage.Subject = $EmailSubject
$MailMessage.Body = $EmailBody

# Attach the CSV file to the email
$Attachment = New-Object System.Net.Mail.Attachment($AttachmentPath)
$MailMessage.Attachments.Add($Attachment)

# Create a new SmtpClient object
$SmtpClient = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
$SmtpClient.EnableSsl = $true

# Send the email
try {
    $SmtpClient.Send($MailMessage)
    Write-Host "Email sent successfully."
} catch {
    Write-Host $_.Exception.Message
}

# Clean up resources
if ($SqlConnection.State -eq "Open") {
    $SqlConnection.Close()
}
