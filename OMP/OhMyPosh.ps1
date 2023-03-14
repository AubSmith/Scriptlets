winget install JanDeDobbeleer.OhMyPosh -s winget

Install-Module -Name Terminal-Icons -Repository PSGallery

# Test PowerShell profile path
Test-Path $Profile

# Create PowerShell profile
New-Item –Path $Profile –Type File –Force

# Add to PowerShell profile
# oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression

# Add nerd font as required

oh-my-posh font install


# New instructions
# PowerShell
winget install oh-my-posh

notepad $Profile
# Update PS profile

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install fonts
# Load NF in Terminal
