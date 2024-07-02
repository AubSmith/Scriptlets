﻿
$directory = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Verbose PSScriptAnalyzer
$testRootDirectory = Split-Path -Parent $directory
Import-Module (Join-Path $testRootDirectory 'PSScriptAnalyzerTestHelper.psm1')
$sa = Get-Command Get-ScriptAnalyzerRule

$singularNouns = "PSUseSingularNouns" # this rule does not exist for coreclr version
$approvedVerbs = "PSUseApprovedVerbs"
$cmdletAliases = "PSAvoidUsingCmdletAliases"
$dscIdentical = "PSDSCUseIdenticalParametersForDSC"

Describe "Test available parameters" {
    $params = $sa.Parameters
    Context "Name parameter" {
        It "has a RuleName parameter" {
            $params.ContainsKey("Name") | Should Be $true
        }

        It "accepts string" {
            $params["Name"].ParameterType.FullName | Should Be "System.String[]"
        }
    }

    Context "RuleExtension parameters" {
        It "has a RuleExtension parameter" {
            $params.ContainsKey("CustomRulePath") | Should Be $true
        }

        It "accepts string array" {
            $params["CustomRulePath"].ParameterType.FullName | Should Be "System.String[]"
        }

		It "takes CustomizedRulePath parameter as an alias of CustomRulePath parameter" {
			$params.CustomRulePath.Aliases.Contains("CustomizedRulePath") | Should be $true
		}
    }

}

Describe "Test Name parameters" {
    Context "When used correctly" {
        It "works with 1 name" {
            $rule = Get-ScriptAnalyzerRule -Name $cmdletAliases
            $rule.Count | Should Be 1
            $rule[0].RuleName | Should Be $cmdletAliases
        }

        It "works for DSC Rule" {
            $rule = Get-ScriptAnalyzerRule -Name $dscIdentical
            $rule.Count | Should Be 1
            $rule[0].RuleName | Should Be $dscIdentical
        }

        It "works with 2 names" {
            $rules = Get-ScriptAnalyzerRule -Name $approvedVerbs, $cmdletAliases
            $rules.Count | Should Be 2
            ($rules | Where-Object {$_.RuleName -eq $cmdletAliases}).Count | Should Be 1
            ($rules | Where-Object {$_.RuleName -eq $approvedVerbs}).Count | Should Be 1
        }

        It "get Rules with no parameters supplied" {
			$defaultRules = Get-ScriptAnalyzerRule
            $expectedNumRules = 49
            if ((Test-PSEditionCoreClr) -or (Test-PSVersionV3) -or (Test-PSVersionV4))
            {
                # for PSv3 PSAvoidGlobalAliases is not shipped because
                # it uses StaticParameterBinder.BindCommand which is
                # available only on PSv4 and above
                # for PowerShell Core, PSUseSingularNouns is not
                # shipped because it uses APIs that are not present
                # in dotnet core.
                $expectedNumRules = 48
            }
			$defaultRules.Count | Should be $expectedNumRules
		}

        It "is a positional parameter" {
            $rules = Get-ScriptAnalyzerRule "PSAvoidUsingCmdletAliases"
            $rules.Count | Should Be 1
        }
    }

    Context "When used incorrectly" {
        It "1 incorrect name" {
            $rule = Get-ScriptAnalyzerRule -Name "This is a wrong name"
            $rule.Count | Should Be 0
        }

        It "1 incorrect and 1 correct" {
            $rule = Get-ScriptAnalyzerRule -Name $cmdletAliases, "This is a wrong name"
            $rule.Count | Should Be 1
            $rule[0].RuleName | Should Be $cmdletAliases
        }
    }
}

Describe "Test RuleExtension" {
    $community = "CommunityAnalyzerRules"
    $measureRequired = "Measure-RequiresModules"
    Context "When used correctly" {

		$expectedNumCommunityRules = 10
		if ($PSVersionTable.PSVersion -ge [Version]'4.0.0')
		{
			$expectedNumCommunityRules = 12
		}
        It "with the module folder path" {
            $ruleExtension = Get-ScriptAnalyzerRule -CustomizedRulePath $directory\CommunityAnalyzerRules | Where-Object {$_.SourceName -eq $community}
            $ruleExtension.Count | Should Be $expectedNumCommunityRules
        }

        It "with the psd1 path" {
            $ruleExtension = Get-ScriptAnalyzerRule -CustomizedRulePath $directory\CommunityAnalyzerRules\CommunityAnalyzerRules.psd1 | Where-Object {$_.SourceName -eq $community}
            $ruleExtension.Count | Should Be $expectedNumCommunityRules

        }

        It "with the psm1 path" {
            $ruleExtension = Get-ScriptAnalyzerRule -CustomizedRulePath $directory\CommunityAnalyzerRules\CommunityAnalyzerRules.psm1 | Where-Object {$_.SourceName -eq $community}
            $ruleExtension.Count | Should Be $expectedNumCommunityRules
        }

        It "with Name of a built-in rules" {
            $ruleExtension = Get-ScriptAnalyzerRule -CustomizedRulePath $directory\CommunityAnalyzerRules\CommunityAnalyzerRules.psm1 -Name $singularNouns
            $ruleExtension.Count | Should Be 0
        }

        It "with Names of built-in, DSC and non-built-in rules" {
            $ruleExtension = Get-ScriptAnalyzerRule -CustomizedRulePath $directory\CommunityAnalyzerRules\CommunityAnalyzerRules.psm1 -Name $singularNouns, $measureRequired, $dscIdentical
            $ruleExtension.Count | Should be 1
            ($ruleExtension | Where-Object {$_.RuleName -eq $measureRequired}).Count | Should Be 1
            ($ruleExtension | Where-Object {$_.RuleName -eq $singularNouns}).Count | Should Be 0
            ($ruleExtension | Where-Object {$_.RuleName -eq $dscIdentical}).Count | Should Be 0
        }
    }

    Context "When used incorrectly" {
        It "file cannot be found" {
            try
            {
                Get-ScriptAnalyzerRule -CustomRulePath "Invalid CustomRulePath"
            }
            catch
            {
                $Error[0].FullyQualifiedErrorId | should match "PathNotFound,Microsoft.Windows.PowerShell.ScriptAnalyzer.Commands.GetScriptAnalyzerRuleCommand"
            }
        }

    }
}

Describe "TestSeverity" {
    It "filters rules based on the specified rule severity" {
        $rules = Get-ScriptAnalyzerRule -Severity Error
        $rules.Count | Should be 6
    }

    It "filters rules based on multiple severity inputs"{
        $rules = Get-ScriptAnalyzerRule -Severity Error,Information
        $rules.Count | Should be 13
    }

        It "takes lower case inputs" {
        $rules = Get-ScriptAnalyzerRule -Severity error
        $rules.Count | Should be 6
    }
}

Describe "TestWildCard" {
    It "filters rules based on the -Name wild card input" {
        $rules = Get-ScriptAnalyzerRule -Name PSDSC*
        $rules.Count | Should be 7
    }

    It "filters rules based on wild card input and severity"{
        $rules = Get-ScriptAnalyzerRule -Name PSDSC*　-Severity Information
        $rules.Count | Should be 4
    }
}
