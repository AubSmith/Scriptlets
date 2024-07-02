﻿
Import-Module PSScriptAnalyzer
$violationMessage = "The cmdlet 'Comment' does not have a help comment."
$violationName = "PSProvideCommentHelp"
$directory = Split-Path -Parent $MyInvocation.MyCommand.Path
$violations = Invoke-ScriptAnalyzer $directory\BadCmdlet.ps1 | Where-Object {$_.RuleName -eq $violationName}

if ($PSVersionTable.PSVersion -ge [Version]'5.0.0')
{
    $dscViolations = Invoke-ScriptAnalyzer -ErrorAction SilentlyContinue $directory\DSCResources\MyDscResource\MyDscResource.psm1 | Where-Object {$_.RuleName -eq $violationName}
}

$noViolations = Invoke-ScriptAnalyzer $directory\GoodCmdlet.ps1 | Where-Object {$_.RuleName -eq $violationName}

Describe "ProvideCommentHelp" {
    Context "When there are violations" {
        It "has 2 provide comment help violations" {
            $violations.Count | Should Be 2
        }

        It "has the correct description message" {
            $violations[1].Message | Should Match $violationMessage
        }

        It "has extent that includes only the function name" {
            $violations[1].Extent.Text | Should Be "Comment"
        }

        if ($PSVersionTable.PSVersion -ge [Version]'5.0.0')
        {
            It "Does not count violation in DSC class" {
                $dscViolations.Count | Should Be 0
            }
        }
    }

    Context "When there are no violations" {
        It "returns no violations" {
            $noViolations.Count | Should Be 0
        }
    }
}