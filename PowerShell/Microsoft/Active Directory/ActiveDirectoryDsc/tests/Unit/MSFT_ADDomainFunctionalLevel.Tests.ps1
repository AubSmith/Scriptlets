$script:dscModuleName = 'ActiveDirectoryDsc'
$script:dscResourceName = 'MSFT_ADDomainFunctionalLevel'

function Invoke-TestSetup
{
    try
    {
        Import-Module -Name DscResource.Test -Force -ErrorAction 'Stop'
    }
    catch [System.IO.FileNotFoundException]
    {
        throw 'DscResource.Test module dependency not found. Please run ".\build.ps1 -Tasks build" first.'
    }

    $script:testEnvironment = Initialize-TestEnvironment `
        -DSCModuleName $script:dscModuleName `
        -DSCResourceName $script:dscResourceName `
        -ResourceType 'Mof' `
        -TestType 'Unit'
}

function Invoke-TestCleanup
{
    Restore-TestEnvironment -TestEnvironment $script:testEnvironment
}

# Begin Testing

Invoke-TestSetup

try
{
    InModuleScope $script:dscResourceName {
        Set-StrictMode -Version 1.0

        # Load the AD Module Stub, so we can mock the cmdlets, then load the AD types.
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'Stubs\ActiveDirectory_2019.psm1') -Force

        $mockDefaultParameters = @{
            DomainIdentity = 'contoso.com'
            DomainMode     = 'Windows2016Domain'
        }

        Describe 'MSFT_ADDomainFunctionalLevel\Get-TargetResource' -Tag 'Get' {
            Context 'When the current property values are returned' {
                BeforeAll {
                    Mock -CommandName Get-ADDomain -MockWith {
                        return @{
                            DomainMode = 'Windows2012R2Domain'
                        }
                    }
                }

                It 'Should return the the same values as was passed as parameters' {
                    $getTargetResourceResult = Get-TargetResource @mockDefaultParameters
                    $getTargetResourceResult.DomainIdentity | Should -Be $mockDefaultParameters.DomainIdentity

                    Assert-MockCalled -CommandName Get-ADDomain -Exactly -Times 1 -Scope It
                }

                It 'Should return the correct value for DomainMode' {
                    $getTargetResourceResult = Get-TargetResource @mockDefaultParameters
                    $getTargetResourceResult.DomainMode | Should -Be 'Windows2012R2Domain'

                    Assert-MockCalled -CommandName Get-ADDomain -Exactly -Times 1 -Scope It
                }
            }
        }

        Describe 'MSFT_ADDomainFunctionalLevel\Test-TargetResource' -Tag 'Test' {
            Context 'When the system is in the desired state' {
                Context 'When the property DomainMode is in desired state' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'DomainMode'
                                    InDesiredState = $true
                                }
                            )
                        }
                    }

                    It 'Should return $true' {
                        $testTargetResourceResult = Test-TargetResource @mockDefaultParameters
                        $testTargetResourceResult | Should -BeTrue

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property DomainMode is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'DomainMode'
                                    InDesiredState = $false
                                }
                            )
                        }

                        $testTargetResourceParameters = $mockDefaultParameters.Clone()
                        $testTargetResourceParameters['DomainMode'] = 'Windows2012R2Domain'
                    }

                    It 'Should return $false' {
                        $testTargetResourceResult = Test-TargetResource @testTargetResourceParameters
                        $testTargetResourceResult | Should -BeFalse

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADDomainFunctionalLevel\Compare-TargetResourceState' -Tag 'Compare' {
            Context 'When the system is in the desired state' {
                Context 'When the property DomainMode is in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                DomainIdentity = 'contoso.com'
                                DomainMode     = $mockDefaultParameters.DomainMode
                            }
                        }
                    }

                    It 'Should return $true' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @mockDefaultParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'DomainMode' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be $mockDefaultParameters.DomainMode
                        $comparedReturnValue.Actual | Should -Be $mockDefaultParameters.DomainMode
                        $comparedReturnValue.InDesiredState | Should -BeTrue

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property DomainMode is not in desired state' {
                    BeforeAll {
                        Mock -CommandName Get-TargetResource -MockWith {
                            return @{
                                DomainIdentity = 'contoso.com'
                                DomainMode     = $mockDefaultParameters.DomainMode
                            }
                        }

                        $compareTargetResourceStateParameters = $mockDefaultParameters.Clone()
                        $compareTargetResourceStateParameters['DomainMode'] = 'Windows2012R2Domain'
                    }

                    It 'Should return $false' {
                        $compareTargetResourceStateResult = Compare-TargetResourceState @compareTargetResourceStateParameters
                        $compareTargetResourceStateResult | Should -HaveCount 1

                        $comparedReturnValue = $compareTargetResourceStateResult.Where( { $_.ParameterName -eq 'DomainMode' })
                        $comparedReturnValue | Should -Not -BeNullOrEmpty
                        $comparedReturnValue.Expected | Should -Be 'Windows2012R2Domain'
                        $comparedReturnValue.Actual | Should -Be $mockDefaultParameters.DomainMode
                        $comparedReturnValue.InDesiredState | Should -BeFalse

                        Assert-MockCalled -CommandName Get-TargetResource -Exactly -Times 1 -Scope It
                    }
                }
            }
        }

        Describe 'MSFT_ADDomainFunctionalLevel\Set-TargetResource' -Tag 'Set' {
            Context 'When the system is in the desired state' {
                Context 'When the property DomainMode is in desired state' {
                    BeforeAll {
                        Mock -CommandName Set-ADDomainMode
                        Mock -CommandName Compare-TargetResourceState -MockWith {
                            return @(
                                @{
                                    ParameterName  = 'DomainMode'
                                    Actual         = 'Windows2016Domain'
                                    Expected       = 'Windows2016Domain'
                                    InDesiredState = $true
                                }
                            )
                        }
                    }

                    It 'Should not throw and do not call Set-CimInstance' {
                        { Set-TargetResource @mockDefaultParameters } | Should -Not -Throw

                        Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Set-ADDomainMode -Exactly -Times 0 -Scope It
                    }
                }
            }

            Context 'When the system is not in the desired state' {
                Context 'When the property DomainMode is not in desired state' {
                    Context 'When desired domain mode should be ''Windows2012R2Domain''' {
                        BeforeAll {
                            Mock -CommandName Set-ADDomainMode
                            Mock -CommandName Compare-TargetResourceState -MockWith {
                                return @(
                                    @{
                                        ParameterName  = 'DomainMode'
                                        Actual         = 'Windows2016Domain'
                                        Expected       = 'Windows2012R2Domain'
                                        InDesiredState = $false
                                    }
                                )
                            }

                            $setTargetResourceParameters = $mockDefaultParameters.Clone()
                            $setTargetResourceParameters['DomainMode'] = 'Windows2012R2Domain'
                        }

                        It 'Should not throw and call the correct mocks' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Set-ADDomainMode -Exactly -Times 1 -Scope It
                        }
                    }

                    Context 'When desired domain mode should be ''Windows2016Domain''' {
                        BeforeAll {
                            Mock -CommandName Set-ADDomainMode
                            Mock -CommandName Compare-TargetResourceState -MockWith {
                                return @(
                                    @{
                                        ParameterName  = 'DomainMode'
                                        Actual         = 'Windows2012R2Domain'
                                        Expected       = 'Windows2016Domain'
                                        InDesiredState = $false
                                    }
                                )
                            }

                            $setTargetResourceParameters = $mockDefaultParameters.Clone()
                            $setTargetResourceParameters['DomainMode'] = 'Windows2016Domain'
                        }

                        It 'Should not throw and call the correct mocks' {
                            { Set-TargetResource @setTargetResourceParameters } | Should -Not -Throw

                            Assert-MockCalled -CommandName Compare-TargetResourceState -Exactly -Times 1 -Scope It
                            Assert-MockCalled -CommandName Set-ADDomainMode -Exactly -Times 1 -Scope It
                        }
                    }
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
