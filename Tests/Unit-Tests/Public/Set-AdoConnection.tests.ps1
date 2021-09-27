[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Suppress false positives in BeforeAll scriptblock')]
param()

$BuildVarModuleFilePath = Join-Path -Path ($PSScriptRoot -replace "Tests.+") -ChildPath "Helpers" -AdditionalChildPath "Set-TestHelpersEnvVars.ps1"
. $BuildVarModuleFilePath -Path $PSCommandPath

Describe "$ENV:THFunctionName" {

    BeforeAll {
        $FunctionName = $ENV:THFunctionName
        . $ENV:THFunctionPath

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
        It "Does not contain untested parameters" {
            $ParamInfo = (Get-Command $FunctionName).Parameters
            $ParamInfo.Count -13 | Should -Be 3
        }

        It "Has a mandatory Url parameter" {
            $ParamInfo = (Get-Command $FunctionName).Parameters["Url"]
            $ParamInfo | Should -Not -BeNullOrEmpty
            $ParamInfo.ParameterType.ToString() | Should -Be "System.String"
            $ParamInfo.Attributes.Mandatory | Should -Be $true
        }

        It "Has a mandatory Project parameter" {
            $ParamInfo = (Get-Command $FunctionName).Parameters["Project"]
            $ParamInfo | Should -Not -BeNullOrEmpty
            $ParamInfo.ParameterType.ToString() | Should -Be "System.String"
            $ParamInfo.Attributes.Mandatory | Should -Be $true
        }
        
        It "Has a mandatory PersonalAccessToken parameter" {
            $ParamInfo = (Get-Command $FunctionName).Parameters["PersonalAccessToken"]
            $ParamInfo | Should -Not -BeNullOrEmpty
            $ParamInfo.ParameterType.ToString() | Should -Be "System.String"
            $ParamInfo.Attributes.Mandatory | Should -Be $true
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

