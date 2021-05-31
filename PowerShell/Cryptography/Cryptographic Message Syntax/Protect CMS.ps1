$FilePath = Get-ChildItem -Path .\ -Filter *.key -Recurse

$FilePath | % { 

    Get-Content $_.FullName | Protect-CmsMessage -To 'C:\Code\File Encryption.cer' -OutFile $_.Fullname
    
}