Function Test-HelpMessage
{
 Param(
    [Parameter(Mandatory=$true, HelpMessage="Enter your name please")]
    $name)
    "Good to meet you $name"
}