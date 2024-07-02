$PSVersionTable


Send-MailMessage -From 'User01 <user01@fabrikam.com>' 
                    -To 'User02 <user02@fabrikam.com>', 'User03 <user03@fabrikam.com>' , 'ITGroup <itdept@fabrikam.com>' 
                    -Cc 'ITMgr <itmgr@fabrikam.com>'
                    -Subject 'Sending the Attachment' 
                    -Body "Forgot to send the attachment. Sending now." 
                    -Attachments .\data.csv
                    -Priority High 
                    -DeliveryNotificationOption OnSuccess, OnFailure 
                    -SmtpServer 'smtp.fabrikam.com'
                    -Port 25
                    -Credential domain01\admin01
                    -UseSsl