Function Test-Positional
{
 Param(
 [Parameter(Position=0)]
 $greeting,
 $name)
 "$greeting $name"
}