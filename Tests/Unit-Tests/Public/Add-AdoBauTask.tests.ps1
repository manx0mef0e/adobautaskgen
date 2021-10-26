[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Suppress false positives in BeforeAll scriptblock')]
param()

Set-BuildEnvironment -Path ($PSScriptRoot -replace "Tests.+") -Force

Describe "Add-AdoBauTask" {
    BeforeAll {
        $FunctionName = "Add-AdoBauTask"
        $FunctionPath = $PSCommandPath -replace ".+Unit-Tests", $ENV:BHPSModulePath -replace "\.tests"
        . $FunctionPath

        $FuncDependancies = @{
            Private = @(
                "Get-FullTitle"
                "ConvertFrom-MarkdownToHtml"
            )
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
            $ParameterInfo.Count -11 | Should -Be 5
        }

        It "Has a mandatory Title parameter" {
            $Function | Should -HaveParameter "Title" -Type "string" -Mandatory
        }

        It "Has a mandatory Description parameter" {
            $Function | Should -HaveParameter "Description" -Type "string" -Mandatory
        }

        It "Has a mandatory ParentId parameter" {
            $Function | Should -HaveParameter "ParentId" -Type "int" -Mandatory
        }

        It "Has a mandatory Frequency parameter" {
            $Function | Should -HaveParameter "Frequency" -Type "string" -Mandatory
        }

        It "Has a mandatory RunDate parameter" {
            $Function | Should -HaveParameter "RunDate" -Type "int" -Mandatory
        }
    }

    Context "Core functionality" {

    }
}
