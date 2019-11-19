#Generated Form Function 
function GenerateForm { 
######################################################################## 

########################################################################

#region Import the Assemblies 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
#endregion

#region Generated Form Objects 
$HelpDeskForm = New-Object System.Windows.Forms.Form
$HelpDeskForm.Text = “ANZ Account Utility”
$HelpDeskForm.Size = New-Object System.Drawing.Size(640,480)

$LastnameLabel = New-Object System.Windows.Forms.Label
$LastnameLabel.Location = New-Object System.Drawing.Size(10,20) 
$LastnameLabel.Size = New-Object System.Drawing.Size(280,20) 
$LastnameLabel.Text = "Lastname:"
$HelpDeskForm.Controls.Add($LastnameLabel)

$LastnameTextBox = New-Object System.Windows.Forms.TextBox 
$LastnameTextBox.Location = New-Object System.Drawing.Size(10,40) 
$LastnameTextBox.Size = New-Object System.Drawing.Size(260,20) 
$HelpDeskForm.Controls.Add($LastnameTextBox)

$FirstnameLabel = New-Object System.Windows.Forms.Label
$FirstnameLabel.Location = New-Object System.Drawing.Size(290,20) 
$FirstnameLabel.Size = New-Object System.Drawing.Size(280,20) 
$FirstnameLabel.Text = "Firstname:"
$HelpDeskForm.Controls.Add($FirstnameLabel)

$FirstnameTextBox = New-Object System.Windows.Forms.TextBox 
$FirstnameTextBox.Location = New-Object System.Drawing.Size(290,40) 
$FirstnameTextBox.Size = New-Object System.Drawing.Size(260,20) 
$HelpDeskForm.Controls.Add($FirstnameTextBox)

$LASTNAME = New-Object System.Windows.Forms.TextBox 
$FIRSTNAME = New-Object System.Windows.Forms.TextBox 
$UnlockAccountButton = New-Object System.Windows.Forms.Button 
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState  
#endregion Generated Form Objects

#———————————————- 
#Generated Event Script Blocks 
#———————————————- 
#Provide Custom Code for events specified in PrimalForms. 
$handler_UnlockAccountButton_Click= 
{ 

#Perform the unlock


$USERFIRSTNAME=$FIRSTNAME.TEXT 
$USERLASTNAME=$LASTNAME.TEXT

Import-Module ActiveDirectory
CD AD:

GET-ADUSER –FirstName $USERFIRSTNAME –LastName $USERLASTNAME | UNLOCK-ADAccount

}

$OnLoadForm_StateCorrection= 
{#Correct the initial state of the form to prevent the .Net maximized form issue 
$HelpDeskForm.WindowState = $InitialFormWindowState 
}

#———————————————- 
#region Generated Form Code 

$UnlockAccountButton.TabIndex = 0 
$UnlockAccountButton.Name = “UnlockAccountButton” 
$UnlockAccountButton.Location = New-Object System.Drawing.Size(100,200)
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

## Generate Tab

         $TabControl = New-object System.Windows.Forms.TabControl
         $ADTab = New-Object System.Windows.Forms.TabPage
         $KayakoTab = New-Object System.Windows.Forms.TabPage
        $WieIsWieTab = New-Object System.Windows.Forms.TabPage

$MSAPage = New-Object System.Windows.Forms.TabPage
$MSAPage.DataBindings.DefaultDataSourceUpdateMode = 0
$MSAPage.UseVisualStyleBackColor = $True
$MSAPage.Text = "Create MSA”
$TabControl.Controls.Add($MSAPage)
        
        #Tab Control 
        $tabControl.DataBindings.DefaultDataSourceUpdateMode = 0
        $tabControl.Location = $System_Drawing_Point
        $tabControl.Name = "tabControl"
        
        $mainform.Controls.Add($tabControl)
        
        $tabControl.Controls.Add($ADTab)
        $tabControl.Controls.Add($WieIsWieTab)
        $tabControl.Controls.Add($KayakoTab)
        
When the program is loaded, i do the following:
        
        $KayakoTabWasLoaded = 0
        # I set the counter to 0 as the tab is not yet been selected
        
                $handler_tabpage_SelectedIndexChanged_KayakoTab = {
        	            if($KayakoTabWasLoaded -lt 1){ # if the tab has not yet been selected, include the file with the needed functions
        		        if ($TabControl.SelectedTab.Name -eq "KayakoUser")	{
        			        Write-Host "You have selected the tab KayakoTab for the first time, file got included."
        			        . .\include\kayako_tab.ps1				
        			        $KayakoTabWasLoaded++
        		        }
        	        }else{ Write-Host "File kayako_tab.ps1 already included."} # the tab was selected before so do nothing
            }
        
    $TabControl.add_SelectedIndexChanged($handler_tabpage_SelectedIndexChanged_ADTab)
    $TabControl.add_SelectedIndexChanged($handler_tabpage_SelectedIndexChanged_WieIsWieTab)
    $TabControl.add_SelectedIndexChanged($handler_tabpage_SelectedIndexChanged_KayakoTab)

##

#Save the initial state of the form 
$InitialFormWindowState = $HelpDeskForm.WindowState 
#Init the OnLoad event to correct the initial state of the form 
$HelpDeskForm.add_Load($OnLoadForm_StateCorrection) 
#Show the Form 
$HelpDeskForm.ShowDialog()| Out-Null

} #End Function

#Call the Function
GENERATEFORM 