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
    <#
        BeforeAll {
            $Function = Get-Command $FunctionName
        }

        It "Does not contain untested parameters" {
            $ParameterInfo = $Function.Parameters
            $ParameterInfo.Count - 11 | Should -Be 3
        }

        It "Has a mandatory switch 'Enable' parameter" {
            $Function | Should -HaveParameter Enable -Type Switch -Mandatory
        }
    #>
        It "Does not contain untested parameters" {
            $ParamInfo = (Get-Command $FunctionName).Parameters
            $ParamInfo.Count -11 | Should -Be 3
        }

        It "Title parameter is member of correct parametersets" {
            $Function = Get-Command $FunctionName
            $FunctionParameters = $Function.Parameters
            $ParamInfo = $FunctionParameters["Title"]
            $ParameterSets = $ParamInfo.ParameterSets
            $ParameterSets["Frequency"] | Should -Not -BeNullOrEmpty
            $ParameterSets["Specific"] | Should -Not -BeNullOrEmpty
            $ParameterSets.Count | Should -Be 2
        }

        It "Frequency parameter is member of correct parametersets" {
            $Function = Get-Command $FunctionName
            $FunctionParameters = $Function.Parameters
            $ParamInfo = $FunctionParameters["Frequency"]
            $ParameterSets = $ParamInfo.ParameterSets
            $ParameterSets["Frequency"] | Should -Not -BeNullOrEmpty
            $ParameterSets.Count | Should -Be 1
        }

        It "RunDate parameter is member of correct parametersets" {
            $Function = Get-Command $FunctionName
            $FunctionParameters = $Function.Parameters
            $ParamInfo = $FunctionParameters["RunDate"]
            $ParameterSets = $ParamInfo.ParameterSets
            $ParameterSets["Specific"] | Should -Not -BeNullOrEmpty
            $ParameterSets.Count | Should -Be 1
        }

        It "Has a mandatory Title parameter" {
            $ParamInfo = (Get-Command $FunctionName).Parameters["Title"]
            $ParamInfo | Should -Not -BeNullOrEmpty
            $ParamInfo.ParameterType.ToString() | Should -Be "System.String"
            $ParamInfo.Attributes.Mandatory | Should -Be @($true, $true)
        }

        It "Has a mandatory Frequency parameter" {
            $ParamInfo = (Get-Command $FunctionName).Parameters["Frequency"]
            $ParamInfo | Should -Not -BeNullOrEmpty
            $ParamInfo.ParameterType.ToString() | Should -Be "System.String"
            $ParamInfo.Attributes.Mandatory | Should -Be $true
            $ParamInfo.Attributes.ValidValues | Should -Be @(
                "Daily",
                "Weekly",
                "Monthly",
                "Quarterly",
                "Half-Yearly",
                "Yearly"
            )
        }

        It "Has a mandatory RunDate parameter" {
            $ParamInfo = (Get-Command $FunctionName).Parameters["RunDate"]
            $ParamInfo | Should -Not -BeNullOrEmpty
            $ParamInfo.ParameterType | Should -Be "int"
            $ParamInfo.Attributes.Mandatory | Should -Be $true
        }
    }

    Context "Core functionality" {
        BeforeAll {
            $Date = Get-Date -Format %d
            $Month = Get-Date -Format MMM
            $FullMonth = Get-Date -UFormat %B
            $RunDate = Get-Random -Minimum 1 -Maximum 28
            $DayofWeek = (Get-Date).DayOfWeek
            $WeekofYear = Get-Date -UFormat %V
            $Quarter = $([math]::Ceiling($Today.Month / 3))
            $YearHalf = $([math]::Ceiling($Today.Month / 6))
            $Year = (Get-Date).Year
        }

        It "Returns a RunDate that is correctly formatted" {
            $TitleTest = Get-FullTitle -Title $Title -RunDate $RunDate
            $TitleTest -like "$RunDate $($Month): $Title" | Should -Be $true
        }

        It "Returns expected string when frequency is Daily" {
            $TitleTest = Get-FullTitle -Title $Title -Frequency "Daily"
            $TitleTest -like "$($Dayofweek): $Title" | Should -Be $true
        }

        It "Returns expected string when frequency is Weekly" {
            $TitleTest = Get-FullTitle -Title $Title -Frequency "Weekly"
            $TitleTest -like "Week $($weekofYear): $Title" | Should -Be $true
        }

        It "Returns expected string when frequency is Monthly" {
            $TitleTest = Get-FullTitle -Title $Title -Frequency "Monthly"
            $TitleTest -like "$($FullMonth): $Title" | Should -Be $true
        }

        It "Returns expected string when frequency is Quarterly" {
            $TitleTest = Get-FullTitle -Title $Title -Frequency "Quarterly"
            $TitleTest -like "Q$($Quarter): $Title" | Should -Be $true
        }

        It "Returns expected string when frequency is Half-Yearly" {
            $TitleTest = Get-FullTitle -Title $Title -Frequency "Half-Yearly"
            $TitleTest -like "H$($YearHalf): $Title" | Should -Be $true
        }

        It "Returns expected string when frequency is Yearly" {
            $TitleTest = Get-FullTitle -Title $Title -Frequency "Yearly"
            $TitleTest -like "$($Year): $Title" | Should -Be $true
        }

    }
}


