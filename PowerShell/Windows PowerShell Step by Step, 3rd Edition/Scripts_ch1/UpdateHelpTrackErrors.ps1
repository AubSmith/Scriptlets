# UpdateHelpTrackErrors.ps1
$error.Clear()
Update-Help -Module * -Force -ea 0
For ($i = 0 ; $i -lt $error.Count ; $i ++) 
  { "`nerror $i" ; $error[$i].exception }
