# List all volumes
Get-Volume

# List Drives
Get-PSDrive -PSProvider 'FileSystem'

# List Disks
Get-Disk

# List system disk
Get-Disk | Where-Object IsSystem -eq True

# List offline disk
Get-Disk | Where-Object IsOffline -eq True

# Initialise disk
Initialize-Disk 1

# Clean a disk for reformatting
Clear-Disk -Number 1 -RemoveData

# Find unformatted disk
Get-Disk | Where-Object PartitionStyle -eq 'RAW' |
# Initialise disk
Initialize-Disk -PassThru |
# Create new partition
New-Partition -AssignDriveLetter -UseMaximumSize |
# Format disk
Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Data'