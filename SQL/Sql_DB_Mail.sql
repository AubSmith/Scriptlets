-- @file_attachments='D:\Admin\file(14072014).csv'!
declare @pathname varchar(200) = 'D:\Admin\file(,' + REPLACE(CONVERT(VARCHAR(10),GETDATE(),101),'/', '') + ', ).csv';

EXEC msdb.dbo.sp_send_dbmail
@recipients='db_notification@wayneent.com',
@body='Good day, <Br>Please find the attachment. <P>Regards<Br> <Br>IT Department', 
@subject ='TOURISM-GL( Auto By System) ',
@body_format = 'html',
@profile_name = 'emailserver',
@file_attachments=@pathname


DECLARE @filenames varchar(max)
DECLARE @file1 VARCHAR(MAX) = 'C:\Testfiles\Test1.csv'
SELECT @filenames = @file1

-- Optional new attachments
DECLARE @file2 VARCHAR(MAX) = ';C:\Testfiles\Test2.csv'
DECLARE @file3 VARCHAR(MAX) = ';C:\Testfiles\Test3.csv'

-- Create list from optional files
SELECT @filenames = @file1 + @file2 + @file3

-- Send the email
EXEC msdb.dbo.sp_send_dbmail
  @profile_name = 'Mod',
  @from_address = 'modis@modisglobal.com',
  @recipients= 'rsmith@gmail.com',
  @subject= 'Test Email', 
  @body = @body1,
  @file_attachments = @filenames;
