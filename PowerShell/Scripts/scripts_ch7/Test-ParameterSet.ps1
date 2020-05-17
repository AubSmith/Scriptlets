Function Test-ParameterSet
{
 Param(
  [Parameter(ParameterSetName="City",Mandatory=$true)]
  $city,
  [Parameter(ParameterSetName="City")]
  $state,
  [Parameter(ParameterSetName="phone",Mandatory=$true)]
  $phone,
  [Parameter(ParameterSetName="phone")]
  $ext,
  [Parameter(Mandatory=$true)]
  $name)
  Switch ($PSCmdlet.ParameterSetName)
  {
   "city" {"$name from $city in $state"}
   "phone" {"$name phone is $Phone extension $ext"}
  }
}