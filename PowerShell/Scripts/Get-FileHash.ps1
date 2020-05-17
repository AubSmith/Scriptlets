#http://jongurgul.com/blog/get-stringhash-get-filehash/
Function Get-FileHash([String] $FileName,$HashName = "MD5")
{
$FileStream = New-Object System.IO.FileStream($FileName,[System.IO.FileMode]::Open)
$StringBuilder = New-Object System.Text.StringBuilder
[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash($FileStream)|%{[Void]$StringBuilder.Append($_.ToString("x2"))}
$FileStream.Close()
$StringBuilder.ToString()
}