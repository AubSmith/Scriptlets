if($New_File = Get-ChildItem 'C:\Test\*.xml' | Where { $_.LastWriteTime -gt (Get-Date).AddHours(-24) }){
	Copy-Item $New_File X:\
}else{
	Write-Host 'File does not exist'
}