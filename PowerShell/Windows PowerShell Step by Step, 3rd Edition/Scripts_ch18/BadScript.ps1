# -----------------------------------------------------------------------------
# Script: BadScript.ps1
# Author: ed wilson, msft
# Date: 7/8/2015
# Keywords: Debugging
# comments: Errors
# Windows PowerShell 5.0 Step by Step, Microsoft Press, 2015
# Chapter 18
# -----------------------------------------------------------------------------

Function AddOne([int]$num)
{
 $num+1
} #end function AddOne

Function AddTwo([int]$num)
{
 $num+2
} #end function AddTwo

Function SubOne([int]$num)
{
 $num-1
} #end function SubOne

Function TimesOne([int]$num)
{
  $num*2
} #end function TimesOne

Function TimesTwo([int]$num)
{
 $num*2
} #end function TimesTwo

Function DivideNum([int]$num)
{ 
 12/$num
} #end function DivideNum

# *** Entry Point to Script ***

$num = 0
SubOne($num) | DivideNum($num)
AddOne($num) | AddTwo($num)
