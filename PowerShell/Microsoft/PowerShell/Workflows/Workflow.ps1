workflow Rename-And-Reboot {
    param ([string]$Name)
    Rename-Computer -NewName $Name -Force -Passthru
    Restart-Computer -Wait
    Do-MoreStuff
  }