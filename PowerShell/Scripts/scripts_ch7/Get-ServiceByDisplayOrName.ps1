function Get-ServiceByDisplayOrName
{
[cmdletbinding(DefaultParameterSetName="name")]
param(
  [Parameter(ParameterSetName="name", Position=0, Mandatory=$true)]
  [string]$name,
  [Parameter(ParameterSetName="Display", Position=0, Mandatory=$true)]
  [string]$display)
  if($name)
    { Get-Service -Name $name }
  if($display) 
    { Get-Service -DisplayName $display }
}
