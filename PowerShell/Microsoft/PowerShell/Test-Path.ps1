if (-not (Test-Path -Path "$Script:srcpath\myfile.txt")){
    Write-Warning 'Does not exist!'
    continue
}else{
    Get-Item $configure
}