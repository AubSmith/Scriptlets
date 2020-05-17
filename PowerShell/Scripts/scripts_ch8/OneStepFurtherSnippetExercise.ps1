$process = Get-WmiObject -Class win32_process
foreach ($item in $process)
{
    $item.name
}