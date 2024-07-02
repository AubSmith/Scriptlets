Import-Module PSScriptAnalyzer
$writeHostName = "PSMisleadingBacktick"
$directory = Split-Path -Parent $MyInvocation.MyCommand.Path
$violationFilepath = Join-Path $directory 'MisleadingBacktick.ps1'
$violations = Invoke-ScriptAnalyzer $violationFilepath | Where-Object {$_.RuleName -eq $writeHostName}
$noViolations = Invoke-ScriptAnalyzer $directory\NoMisleadingBacktick.ps1 | Where-Object {$_.RuleName -eq $clearHostName}
Import-Module (Join-Path $directory "PSScriptAnalyzerTestHelper.psm1")

Describe "Avoid Misleading Backticks" {
    Context "When there are violations" {
        It "has 5 misleading backtick violations" {
            $violations.Count | Should Be 5
        }
	
	It "suggests correction" {
	   Test-CorrectionExtent $violationFilepath $violations[0] 1 ' ' ''
	   Test-CorrectionExtent $violationFilepath $violations[1] 1 ' ' ''
	   Test-CorrectionExtent $violationFilepath $violations[2] 1 ' ' ''
	   Test-CorrectionExtent $violationFilepath $violations[3] 1 '                     ' ''
	   Test-CorrectionExtent $violationFilepath $violations[4] 1 '      ' ''
	}
    }

    Context "When there are no violations" {
        It "returns no violations" {
            $noViolations.Count | Should Be 0
        }
    }
}