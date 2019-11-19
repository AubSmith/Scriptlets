Function Test-PipedValue
{
 Param(
   [Parameter(ValueFromPipeline=$true)]
   $process)
   Process {write-host $process.name  $process.id}
}