$props = @{
    "Parameters" = @(
        @{ Name = "info"; Title = "Fancy Link"; Value = "<a href='https://www.google.com' target='_blank'>CLICK ME</a>"; Editor = "info" }
    )
    "Title" = "Sample Download Wizard"
    "Icon" = "OfficeWhite/32x32/server_from_client.png"
    "ShowHints" = $true
    "OkButtonName" = "Next"
}
Read-Variable @props