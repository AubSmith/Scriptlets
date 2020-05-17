Function Test-PipedValueByPropertyName
{
 Param(
   [Parameter(ValueFromPipelineByPropertyName=$true)]
   $processname,
   [Parameter(ValueFromPipelineByPropertyName=$true)]
   $id)
   Process {write-host $processname  $id}
}