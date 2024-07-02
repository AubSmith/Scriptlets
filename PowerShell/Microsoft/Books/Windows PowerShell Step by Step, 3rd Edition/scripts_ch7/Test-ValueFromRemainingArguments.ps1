Function Test-ValueFromRemainingArguments
{
 Param(
   $Name,
   [Parameter(ValueFromRemainingArguments=$true)]
   $otherInfo)
   Process { "Name: $name `r`nOther info: $otherinfo" }
}