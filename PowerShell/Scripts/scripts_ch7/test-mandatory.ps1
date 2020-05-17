Function Test-Mandatory
{
 Param(
 [Parameter(mandatory=$true)]
 $name)
 "hello $name"
}