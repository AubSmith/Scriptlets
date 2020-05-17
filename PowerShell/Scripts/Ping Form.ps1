[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  

$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(600,400)  

############################################## Start functions

function pingInfo {

if ($RadioButton1.Checked -eq $true) {$nrOfPings=1}
if ($RadioButton2.Checked -eq $true) {$nrOfPings=2}
if ($RadioButton3.Checked -eq $true) {$nrOfPings=3}

$computer=$DropDownBox.SelectedItem.ToString() #populate the var with the value you selected
$pingResult=ping $wks -n $nrOfPings | fl | out-string;
$outputBox.text=$pingResult

                     } #end pingInfo

############################################## end functions

############################################## Start group boxes

$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(270,20) 
$groupBox.size = New-Object System.Drawing.Size(100,100) 
$groupBox.text = "Nr of pings:" 
$Form.Controls.Add($groupBox) 

############################################## end group boxes

############################################## Start radio buttons

$RadioButton1 = New-Object System.Windows.Forms.RadioButton 
$RadioButton1.Location = new-object System.Drawing.Point(15,15) 
$RadioButton1.size = New-Object System.Drawing.Size(80,20) 
$RadioButton1.Checked = $true 
$RadioButton1.Text = "Ping once" 
$groupBox.Controls.Add($RadioButton1) 

$RadioButton2 = New-Object System.Windows.Forms.RadioButton
$RadioButton2.Location = new-object System.Drawing.Point(15,45)
$RadioButton2.size = New-Object System.Drawing.Size(80,20)
$RadioButton2.Text = "Ping twice"
$groupBox.Controls.Add($RadioButton2)

$RadioButton3 = New-Object System.Windows.Forms.RadioButton
$RadioButton3.Location = new-object System.Drawing.Point(15,75)
$RadioButton3.size = New-Object System.Drawing.Size(80,20)
$RadioButton3.Text = "Ping thrice"
$groupBox.Controls.Add($RadioButton3)

############################################## end radio buttons

############################################## Start drop down boxes

$DropDownBox = New-Object System.Windows.Forms.ComboBox
$DropDownBox.Location = New-Object System.Drawing.Size(20,50) 
$DropDownBox.Size = New-Object System.Drawing.Size(180,20) 
$DropDownBox.DropDownHeight = 200 
$Form.Controls.Add($DropDownBox) 

$wksList=@("hrcomputer1","hrcomputer2","hrcomputer3","workstation1","workstation2","computer5","localhost")

foreach ($wks in $wksList) {
                      $DropDownBox.Items.Add($wks)
                              } #end foreach

############################################## end drop down boxes

############################################## Start text fields

$outputBox = New-Object System.Windows.Forms.TextBox 
$outputBox.Location = New-Object System.Drawing.Size(10,150) 
$outputBox.Size = New-Object System.Drawing.Size(565,200) 
$outputBox.MultiLine = $True 

$outputBox.ScrollBars = "Vertical" 
$Form.Controls.Add($outputBox) 

############################################## end text fields

############################################## Start buttons

$Button = New-Object System.Windows.Forms.Button 
$Button.Location = New-Object System.Drawing.Size(400,30) 
$Button.Size = New-Object System.Drawing.Size(110,80) 
$Button.Text = "Ping" 
$Button.Add_Click({pingInfo}) 
$Form.Controls.Add($Button) 

############################################## end buttons

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()