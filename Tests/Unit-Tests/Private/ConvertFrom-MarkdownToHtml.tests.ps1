[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Suppress false positives in BeforeAll scriptblock')]
param()

# $BuildVarModuleFilePath = Join-Path -Path ($PSScriptRoot -replace "Tests.+") -ChildPath "Helpers" -AdditionalChildPath "Set-TestHelpersEnvVars.ps1"
# . $BuildVarModuleFilePath -Path $PSCommandPath


Set-BuildEnvironment -Path ($PSScriptRoot -replace "tests.+") -Force

Describe "ConvertFrom-MarkdownToHtml" {
    BeforeAll {
        # $FunctionName = "ConvertFrom-MarkdownToHtml"
        # . $ENV:THFunctionPath

        # $FuncDependancies = @{
        #     Private = @()
        #     Public = @()
        #     Classes = @()
        # }

        # foreach ($Scope in $FuncDependancies.Keys) {
        #     foreach ($Function in $FuncDependancies.$Scope) {
        #         $FuncPath = Join-Path -Path $ENV:BHPSModulePath -ChildPath $Scope -AdditionalChildPath "$Function.ps1"
        #         # Import dependant function into to scope
        #         . $FuncPath
        #     }
        # }


        $FunctionName = "ConvertFrom-MarkdownToHtml"

        $FunctionPath = $PSCommandPath -replace ".+unit-tests", $ENV:BHPSModulePath -replace "\.tests"
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
            # Mock Invoke-WebRequest {
            #     return @{
            #         StatusCode = 200
            #         Content = "good"
            #     }
            # }
        }
        It "It returns content from the github api response" {
            $Result = ConvertFrom-MarkdownToHtml -Markdown "**Bold word**"
            $Result | Should -Be "good"
        }



    }
}


