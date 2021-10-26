[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Suppress false positives in BeforeAll scriptblock')]
param()

Set-BuildEnvironment -Path ($PSScriptRoot -replace "Tests.+") -Force

Describe "ConvertFrom-MarkdownToHtml" {
    BeforeAll {
        $FunctionName = "ConvertFrom-MarkdownToHtml"

        $FunctionPath = $PSCommandPath -replace ".+Unit-Tests", $ENV:BHPSModulePath -replace "\.tests"
        . $FunctionPath

        $FuncDependencies = @{
            classes = @()
            private = @()
            public  = @()
        }
        foreach ($Scope in $FuncDependencies.Keys) {
            foreach ($Function in $FuncDependencies.$Scope) {
                $FuncPath = Join-Path -Path $ENV:BHPSModulePath -ChildPath $Scope -AdditionalChildPath "$Function.ps1"
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
            $ParameterInfo.Count - 11 | Should -Be 1
        }

        It "Has a mandatory string 'Markdown' parameter" {
            $Function | Should -HaveParameter Markdown -Type string -Mandatory
        }
    }

    Context "Core functionality" {
        BeforeAll {
            Mock Invoke-WebRequest {
                return @{
                    StatusCode = 200
                    Content = "good"
                }
            }
        }
        It "It returns content from the github api response" {
            $Result = ConvertFrom-MarkdownToHtml -Markdown "**Bold word**"
            $Result | Should -Be "good"
        }



    }
}


