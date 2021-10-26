[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Suppress false positives in BeforeAll scriptblock')]
param()

Set-BuildEnvironment -Path ($PSScriptRoot -replace "Tests.+") -Force

Describe "Set-AdoConnection" {
    BeforeAll {
        $FunctionName = "Set-AdoConnection"
        $FunctionPath = $PSCommandPath -replace ".+Unit-Tests", $ENV:BHPSModulePath -replace "\.tests"
        . $FunctionPath

        $FuncDependancies = @{
            Private = @()
            Public = @()
            Classes = @()
        }

        foreach ($Scope in $FuncDependancies.Keys) {
            foreach ($Function in $FuncDependancies.$Scope) {
                $FuncPath = Join-Path -Path $ENV:BHPSModulePath -ChildPath $Scope -AdditionalChildPath "$Function.ps1"
                # Import dependant function into to scope
                . $FuncPath
            }
        }
    }

    Context "Parameters" {
        BeforeAll {
            $Function = Get-Command $FunctionName
        }

        It "Does not contain untested parameters" {
            $ParameterInfo = $Function.Parameters
            $ParameterInfo.Count -13 | Should -Be 3
        }

        It "Has a mandatory Url parameter" {
            $Function | Should -HaveParameter "Url" -Type "string" -Mandatory
        }

        It "Has a mandatory Project parameter" {
            $Function | Should -HaveParameter "Project" -Type "string" -Mandatory
        }

        It "Has a mandatory PersonalAccessToken parameter" {
            $Function | Should -HaveParameter "PersonalAccessToken" -Type "string" -Mandatory
        }
    }

    Context "Core functionality" {
        BeforeEach {
            Mock Set-VSTeamAccount
            Mock Set-VSTeamDefaultProject

            Set-AdoConnection -Url "fakeurl" -Project "fakeproject" -PersonalAccessToken "fakepat"
        }

        It "Calls Set-VSTeamAccount" {
            Should -Invoke -CommandName Set-VSTeamAccount -Times 1
        }

        It "Calls Set-VSTeamDefaultProject" {
            Should -Invoke -CommandName Set-VSTeamDefaultProject -Times 1
        }
    }
}

