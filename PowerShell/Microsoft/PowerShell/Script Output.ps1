# powershell.exe ".\Script Output.ps1" > out.txt
Write-Output "test1"; # Will output to out.txt
Write-Host "test2";   # Will output to console
"test3";              # Will output to out.txt

function test {
    Write-Host 123
    echo 456 # AKA 'Write-Output'
    return 789
}

$x = test

Write-Host "This is x:" $x
