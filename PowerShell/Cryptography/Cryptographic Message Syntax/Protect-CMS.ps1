$FilePath = Get-ChildItem -Path .\ -Filter *.txt -Recurse

$FilePath | % { 

    Get-Content $_.FullName | Protect-CmsMessage -To cert_thumbprint -OutFile $_.Fullname
    
} 
