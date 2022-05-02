winget install oh-my-posh

Install-Module -Name Terminal-Icons -Repository PSGallery

# Test PowerShell profile path
Test-Path $Profile

# Create PowerShell profile
New-Item –Path $Profile –Type File –Force

# Add to PowerShell profile
# oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression

# Add nerd font as required