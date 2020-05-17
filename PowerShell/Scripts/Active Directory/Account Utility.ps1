#################################### 
# Author : Aubrey Smith            #
# Date   : 15 September 2016       #
# Version: 1.0                     #
####################################

#Generated Form Function 
function GenerateForm { 

#Region Import the Assemblies 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
#Endregion

#Region Generated Form Objects 
$HelpDeskForm = New-Object System.Windows.Forms.Form
$HelpDeskForm.Text = “ANZ Account Utility”
$HelpDeskForm.Size = New-Object System.Drawing.Size(640,480)

$SAMAccNameLabel = New-Object System.Windows.Forms.Label
$SAMAccNameLabel.Location = New-Object System.Drawing.Size(10,65) 
$SAMAccNameLabel.Size = New-Object System.Drawing.Size(280,20) 
$SAMAccNameLabel.Text = "Username:"
$HelpDeskForm.Controls.Add($SAMAccNameLabel)

$SAMAccNameTextBox = New-Object System.Windows.Forms.TextBox 
$SAMAccNameTextBox.Location = New-Object System.Drawing.Size(10,85) 
$SAMAccNameTextBox.Size = New-Object System.Drawing.Size(260,20) 
$HelpDeskForm.Controls.Add($SAMAccNameTextBox)

$UnlockAccountButton = New-Object System.Windows.Forms.Button 
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState  
#Endregion Generated Form Objects

 
#Events 
$handler_UnlockAccountButton_Click= 
{ 

#Perform the unlock


$SAMAccountName=$SAMAccNameTextBox.TEXT

Import-Module ActiveDirectory
CD AD:

Unlock-ADAccount -Identity $SAMAccountName

}

$OnLoadForm_StateCorrection= 
{#Correct the initial state of the form to prevent the .Net maximized form issue 
$HelpDeskForm.WindowState = $InitialFormWindowState 
}

#———————————————- 
#region Generated Form Code 

$UnlockAccountButton.TabIndex = 0 
$UnlockAccountButton.Name = “UnlockAccountButton” 
$UnlockAccountButton.Location = New-Object System.Drawing.Size(150,200)
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 240
$System_Drawing_Size.Height = 23
$UnlockAccountButton.Size = $System_Drawing_Size 
$UnlockAccountButton.UseVisualStyleBackColor = $True

$UnlockAccountButton.Text = “Unlock Account”

$UnlockAccountButton.DataBindings.DefaultDataSourceUpdateMode = 0 
$UnlockAccountButton.add_Click($handler_UnlockAccountButton_Click)

$HelpDeskForm.Controls.Add($UnlockAccountButton)

#endregion Generated Form Code

#Save the initial state of the form 
$InitialFormWindowState = $HelpDeskForm.WindowState 
#Init the OnLoad event to correct the initial state of the form 
$HelpDeskForm.add_Load($OnLoadForm_StateCorrection) 
#Show the Form 
$HelpDeskForm.ShowDialog()| Out-Null

} #End Function

#Call the Function
GENERATEFORM 