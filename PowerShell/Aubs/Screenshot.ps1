Start-Process Microsoft-Edge:https://www.microsoft.com/en-us/edge -WindowStyle Maximized

Start-Sleep -Seconds 5

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$Width = $Screen.Width
$Height = $Screen.Height
$LeftDimension = $Screen.Left
$TopDimension = $Screen.Top

$Bitmap = New-Object System.Drawing.Bitmap $Width, $Height
$Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
$Graphics.CopyFromScreen($LeftDimension, $TopDimension, 0, 0, $Screen.Size)

# $Bitmap.Save("$env:USERPROFILE\Documents\EdgeScreenshot.png", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$Bitmap.Save("E:\EdgeScreenshot.png", [System.Drawing.Imaging.ImageFormat]::Png)


