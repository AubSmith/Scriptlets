	#################################### 
	# Author : Aubrey Smith            #
	# Date   : 16 September 2016       #
	# Version: 1.0                     #
	####################################
	
	#Generated Form Function 
	function GenerateForm
	{
		
		#region Import the Assemblies 
		[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
		[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
		#endregion
		
		#region Generated Form Objects 
		$CreateMSA = New-Object System.Windows.Forms.Form
		$CreateMSA.Text = "MSA Account Utility"
		$CreateMSA.Size = New-Object System.Drawing.Size(290, 290)
		
		# Set the font of the text to be used within the form
		$Font = New-Object System.Drawing.Font("Arial", 9)
		$CreateMSA.Font = $Font
	
		$AccountLabel = New-Object System.Windows.Forms.Label
		$AccountLabel.Location = New-Object System.Drawing.Size(10, 25)
		$AccountLabel.Size = New-Object System.Drawing.Size(280, 20)
		$AccountLabel.Text = "Username:"
		$CreateMSA.Controls.Add($AccountLabel)
		
		$AccountTextBox = New-Object System.Windows.Forms.TextBox
		$AccountTextBox.Location = New-Object System.Drawing.Size(10, 45)
		$AccountTextBox.Size = New-Object System.Drawing.Size(260, 20)
		$CreateMSA.Controls.Add($AccountTextBox)
		
		$ADServerLabel = New-Object System.Windows.Forms.Label
		$ADServerLabel.Location = New-Object System.Drawing.Size(10, 65)
		$ADServerLabel.Size = New-Object System.Drawing.Size(280, 20)
		$ADServerLabel.Text = "Server:"
		$CreateMSA.Controls.Add($ADServerLabel)
		
		$ADServerTextBox = New-Object System.Windows.Forms.TextBox
		$ADServerTextBox.Location = New-Object System.Drawing.Size(10, 85)
		$ADServerTextBox.Size = New-Object System.Drawing.Size(260, 20)
		$CreateMSA.Controls.Add($ADServerTextBox)
		
		$ADGroupLabel = New-Object System.Windows.Forms.Label
		$ADGroupLabel.Location = New-Object System.Drawing.Size(10, 105)
		$ADGroupLabel.Size = New-Object System.Drawing.Size(280, 20)
		$ADGroupLabel.Text = "Group:"
		$CreateMSA.Controls.Add($ADGroupLabel)
		
		$ADGroupTextBox = New-Object System.Windows.Forms.TextBox
		$ADGroupTextBox.Location = New-Object System.Drawing.Size(10, 125)
		$ADGroupTextBox.Size = New-Object System.Drawing.Size(260, 20)
		$CreateMSA.Controls.Add($ADGroupTextBox)
	
		$ADPathLabel = New-Object System.Windows.Forms.Label
		$ADPathLabel.Location = New-Object System.Drawing.Size(10, 145)
		$ADPathLabel.Size = New-Object System.Drawing.Size(280, 20)
		$ADPathLabel.Text = "Region:"
		$CreateMSA.Controls.Add($ADPathLabel)
	
		$ADPathTextBox = New-Object System.Windows.Forms.TextBox
		$ADPathTextBox.Location = New-Object System.Drawing.Size(10, 165)
		$ADPathTextBox.Size = New-Object System.Drawing.Size(260, 20)
		$CreateMSA.Controls.Add($ADPathTextBox)
	
		$CreateMSAButton = New-Object System.Windows.Forms.Button
		$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
		
		#endregion Generated Form Objects
		
		#———————————————- 
		#Generated Event Script Blocks 
		#———————————————- 
		#Provide Custom Code for events specified in PrimalForms. 
		$handler_CreateMSAButton_Click =
		{
			
			#Create the MSA - Add MSA to group object - Register MSA on server
		
			$ADServer = $ADServerTextBox.TEXT
			$Account = $AccountTextBox.TEXT
			$Path = "OU=Test,OU=" + $ADPathTextBox.Text + ",OU=Smith Users,DC=Smith,DC=com"
			
			Import-Module ActiveDirectory
			CD AD:
		
		New-ADServiceAccount -DNSHostname $ADServer -Name $Account -Path $Path # -AccountPassword $Password 
			
			$ADGroup = $ADGroupTextBox.TEXT
			
			Add-ADGroupMember -Identity $ADGroup -Members $Account$
			
			Add-ADComputerServiceAccount -Identity $ADServer -ServiceAccount $Account$
			
		}
		
		#———————————————- 
		#region Generated Form Code 
		
		$CreateMSAButton.TabIndex = 0
		$CreateMSAButton.Name = "Create MSA"
		$CreateMSAButton.Location = New-Object System.Drawing.Size(15, 200)
		$System_Drawing_Size = New-Object System.Drawing.Size
		$System_Drawing_Size.Width = 240
		$System_Drawing_Size.Height = 23
		$CreateMSAButton.Size = $System_Drawing_Size
		$CreateMSAButton.UseVisualStyleBackColor = $True
		
		$CreateMSAButton.Text = "Create MSA"
		
		$CreateMSAButton.DataBindings.DefaultDataSourceUpdateMode = 0
		$CreateMSAButton.add_Click($handler_CreateMSAButton_Click)
		
		$CreateMSA.Controls.Add($CreateMSAButton)
		
		#endregion Generated Form Code
		
		#Save the initial state of the form 
		$InitialFormWindowState = $CreateMSA.WindowState
		#Init the OnLoad event to correct the initial state of the form 
		$CreateMSA.add_Load($OnLoadForm_StateCorrection)
		#Show the Form 
		$CreateMSA.ShowDialog() | Out-Null
		
	} #End Function
	
	#Call the Function
	GENERATEFORM
