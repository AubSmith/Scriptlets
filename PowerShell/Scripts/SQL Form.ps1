function CreateForm {
#[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.drawing

#Form Setup
$form1 = New-Object System.Windows.Forms.Form
$button1 = New-Object System.Windows.Forms.Button
$button2 = New-Object System.Windows.Forms.Button
$checkBox1 = New-Object System.Windows.Forms.CheckBox
$checkBox2 = New-Object System.Windows.Forms.CheckBox
$checkBox3 = New-Object System.Windows.Forms.CheckBox
$checkBox4 = New-Object System.Windows.Forms.CheckBox
$TabControl = New-object System.Windows.Forms.TabControl
$SQLHealthPage = New-Object System.Windows.Forms.TabPage
$CPUPage = New-Object System.Windows.Forms.TabPage
$DiskPage = New-Object System.Windows.Forms.TabPage
$MemoryPage = New-Object System.Windows.Forms.TabPage

$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

#Form Parameter
$form1.Text = "My PowerShell Form"
$form1.Name = "form1"
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 725
$System_Drawing_Size.Height = 450
$form1.ClientSize = $System_Drawing_Size


#Tab Control 
$tabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 75
$System_Drawing_Point.Y = 85
$tabControl.Location = $System_Drawing_Point
$tabControl.Name = "tabControl"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 300
$System_Drawing_Size.Width = 575
$tabControl.Size = $System_Drawing_Size
$form1.Controls.Add($tabControl)

#SQLHealth Page
$SQLHealthPage.DataBindings.DefaultDataSourceUpdateMode = 0
$SQLHealthPage.UseVisualStyleBackColor = $True
$SQLHealthPage.Name = "SQLHealthPage"
$SQLHealthPage.Text = "SQL Health Check”
$tabControl.Controls.Add($SQLHealthPage)

#CPU Page
$CPUPage.DataBindings.DefaultDataSourceUpdateMode = 0
$CPUPage.UseVisualStyleBackColor = $True
$CPUPage.Name = "CPUPage"
$CPUPage.Text = "CPU”
$tabControl.Controls.Add($CPUPage)

#Disk Page
$DiskPage.DataBindings.DefaultDataSourceUpdateMode = 0
$DiskPage.UseVisualStyleBackColor = $True
$DiskPage.Name = "DiskPage"
$DiskPage.Text = "Disk”
$tabControl.Controls.Add($DiskPage)

#Memory Page
$MemoryPage.DataBindings.DefaultDataSourceUpdateMode = 0
$MemoryPage.UseVisualStyleBackColor = $True
$MemoryPage.Name = "MemoryPage"
$MemoryPage.Text = "Memory”
$tabControl.Controls.Add($MemoryPage)

#Add Label and TextBox
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,45)  
$objLabel.Size = New-Object System.Drawing.Size(110,50)  
$objLabel.Text = "Enter Server Name"
$form1.Controls.Add($objLabel)
$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(120,45) 
$objTextBox.Size = New-Object System.Drawing.Size(200,20)  
$form1.Controls.Add($objTextBox) 
 
#Button 1 Action 
$button1_RunOnClick= 
{   
    if ($checkBox1.Checked)     {  SQLVersion }
    if ($checkBox2.Checked)    {  LastReboot }
    if ($checkBox3.Checked)    {  Requests }   
}

#Button 2 Action
$button2_RunOnClick= 
{   
    if ($checkBox1.Checked) {$checkBox1.CheckState = 0}
    if ($checkBox2.Checked) {$checkBox2.CheckState = 0}
    if ($checkBox3.Checked) {$checkBox3.CheckState = 0}
}

$OnLoadForm_StateCorrection=
{
    $form1.WindowState = $InitialFormWindowState
}
 
#Button 1
$button1.TabIndex = 4
$button1.Name = "button1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 25
$button1.Size = $System_Drawing_Size
$button1.UseVisualStyleBackColor = $True
$button1.Text = "Run"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 350
$System_Drawing_Point.Y = 45
$button1.Location = $System_Drawing_Point
$button1.DataBindings.DefaultDataSourceUpdateMode = 0
$button1.add_Click($button1_RunOnClick)
$form1.Controls.Add($button1)

#Button 2
$button2.TabIndex = 4
$button2.Name = "button2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 25
$button2.Size = $System_Drawing_Size
$button2.UseVisualStyleBackColor = $True
$button2.Text = "Clear CheckBox"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 450
$System_Drawing_Point.Y = 45
$button2.Location = $System_Drawing_Point
$button2.DataBindings.DefaultDataSourceUpdateMode = 0
$button2.add_Click($button2_RunOnClick)
$form1.Controls.Add($button2)


#SQLVersion
$checkBox1.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$checkBox1.Size = $System_Drawing_Size
$checkBox1.TabIndex = 0
$checkBox1.Text = "SQL Version"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 25
$checkBox1.Location = $System_Drawing_Point
$checkBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox1.Name = "checkBox1"
$SQLHealthPage.Controls.Add($checkBox1)



#LastReBoot
$checkBox2.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$checkBox2.Size = $System_Drawing_Size
$checkBox2.TabIndex = 1
$checkBox2.Text = "Last Reboot"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 50
$checkBox2.Location = $System_Drawing_Point
$checkBox2.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox2.Name = "checkBox2"
$SQLHealthPage.Controls.Add($checkBox2)


#Request
$checkBox3.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$checkBox3.Size = $System_Drawing_Size
$checkBox3.TabIndex = 0
$checkBox3.Text = "Requests"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 75
$checkBox3.Location = $System_Drawing_Point
$checkBox3.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox3.Name = "checkBox3"
$SQLHealthPage.Controls.Add($checkBox3)


#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null
} #End function CreateForm
 
 function Invoke-Sqlcmd3

{
    param(
    [string]$Query,             
    [string]$Database="tempdb",
    [Int32]$QueryTimeout=30
    )
    $conn=new-object System.Data.SqlClient.SQLConnection
    $conn.ConnectionString="Server={0};Database={1};Integrated Security=True" -f $Server,$Database
    $conn.Open()
    $cmd=new-object system.Data.SqlClient.SqlCommand($Query,$conn)
    $cmd.CommandTimeout=$QueryTimeout
    $ds=New-Object system.Data.DataSet
    $da=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
    [void]$da.fill($ds)
    $conn.Close()
    $ds.Tables[0]
}

 

Function SQLVersion
{
[string]$SQLVersion = @"
SELECT  @@Version
"@ 
 $Server = $objTextBox.text
Invoke-Sqlcmd3 -ServerInstance $Server -Database Master -Query $SQLVersion | Out-GridView -Title "$server SQL Server Version"
}

Function LastReboot
{
$Server = $objTextBox.text
$wmi = Get-WmiObject -Class Win32_OperatingSystem -Computer $server
$wmi.ConvertToDatetime($wmi.LastBootUpTime) | Select DateTime | Out-GridView -Title "$Server Last Reboot"
}

Function Requests
{
[string]$Requests = @"
SELECT
   db_name(r.database_id) as database_name, r.session_id AS SPID,r.status,s.host_name,
     r.start_time,(r.total_elapsed_time/1000) AS 'TotalElapsedTime Sec',
   r.wait_type as current_wait_type,r.wait_resource as current_wait_resource,
   r.blocking_session_id,r.logical_reads,r.reads,r.cpu_time as cpu_time_ms,r.writes,r.row_count,
   substring(st.text,r.statement_start_offset/2,
   (CASE WHEN r.statement_end_offset = -1 THEN len(convert(nvarchar(max), st.text)) * 2 ELSE r.statement_end_offset END - r.statement_start_offset)/2) as statement
FROM
   sys.dm_exec_requests r
      LEFT OUTER JOIN sys.dm_exec_sessions s on s.session_id = r.session_id
      LEFT OUTER JOIN sys.dm_exec_connections c on c.connection_id = r.connection_id       
      CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st 
WHERE r.status NOT IN ('background','sleeping')
"@ 
 $Server = $objTextBox.text
Invoke-Sqlcmd3 -ServerInstance $Server -Database Master -Query $Requests | Out-GridView -Title "$server Requests"
}



#Call the Function

CreateForm