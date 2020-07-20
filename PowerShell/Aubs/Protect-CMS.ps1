$FilePath = Get-ChildItem -Path .\ -Filter *.cer -Recurse

$FilePath | % { 

    Get-Content $_.FullName | Protect-CmsMessage -To cert_thumbprint -OutFile $_.Fullname
    
} 
