$Folder_1 = "C:\Users\Aubrey Smith\Lego\TradeMe - Lego"
$Folder_2 = "C:\Users\Rosemary Smith\Documents\TradeMe - Lego"
$Folder_3 = "K:\Documents\TradeMe - Lego"
$File = "Lego TradeMe.xslx"

Robocopy $Folder_1  $Folder_2 $File XN
Robocopy $Folder_1  $Folder_3 $File XN
Robocopy $Folder_2  $Folder_1 $File XN
Robocopy $Folder_2  $Folder_3 $File XN
Robocopy $Folder_3  $Folder_1 $File XN
Robocopy $Folder_3  $Folder_2 $File XN