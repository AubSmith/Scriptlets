$path = "Put the path to a pfx file here"
$password = "Put password here"
$pfx = New-Object Security.Cryptography.X509Certificates.X509Certificate2Collection
# import pfx to X509Certificate2 collection
$pfx.Import([IO.File]::ReadAllBytes($path), $password, "Exportable")
# remove first root (self-signed) certificate
if ($pfx.Count -gt 1) {
    for ($i = 0; $i -lt $pfx.Count; $i++) {
        if ($pfx[$i].Issuer -eq $pfx[$i].Subject) {
            [void]$pfx.RemoveAt($i); break
        }
    }
}
# write back pfx to a file
$bytes = $pfx.Export("pfx", $password)
[IO.File]::WriteAllBytes($path, $bytes)