# To use telnet to test SMTP communication

1) Open a telnet session: From a command prompt, type **telnet**, and then press ENTER.

2) Type **set local_echo** on a computer running Microsoft Windows® 2000 Server or **SET LOCALECHO** on a computer running Windows Server™ 2003 or Windows XP, and then press ENTER. This command allows you to view the responses to the commands.

> **_NOTE:_**  For a list of available telnet commands, type **set ?**.

3) Type **o \<your mail server domain\> 25**,and then press ENTER.

4) Type **EHLO \<your mail server domain\>**, and then press ENTER.

5) Type **AUTH LOGIN**. The server responds with an encrypted prompt for your user name.

6) Enter your user name encrypted in base 64. You can use one of several tools that are available to encode your user name.

7) The server responds with an encrypted base 64 prompt for your password. Enter your password encrypted in base 64.

8) Type **MAIL FROM:\<sender@domain.com\>**, and then press ENTER. If the sender is not permitted to send mail, the SMTP server returns an error.

9) Type **RCPT TO:\<recipient@remotedomain.com\>**,and then press ENTER.If the recipient is not a valid recipient or the server does not accept mail for this domain, the SMTP server returns an error.

10) Type **DATA**.

11) If desired, type message text, press ENTER, type a period (.), and then press ENTER again.

12) If mail is working properly, you should see a response similar to the following indicating that mail is queued for delivery:

`250 2.6.0 <INET-IMC-01UWr81nn9000fbad8@mail1.contoso.com.`
