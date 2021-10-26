[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Suppress false positives in BeforeAll scriptblock')]
param()

Set-BuildEnvironment -Path ($PSScriptRoot -replace "Tests.+") -Force

Describe "Get-FullTitle" {
    BeforeAll {
        $FunctionName = "Get-FullTitle"
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
            $ParameterInfo.Count - 11 | Should -Be 3
        }

        It "Has a mandatory Title parameter" {
            $Function | Should -HaveParameter "Title" -Type "string" -Mandatory
        }

        It "Has a mandatory Frequency parameter" {
            $Function | Should -HaveParameter "Frequency" -Type "string" -Mandatory
        }

        It "Has a mandatory RunDate parameter" {
            $Function | Should -HaveParameter "RunDate" -Type "int" -Mandatory
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

    }

    Context "Core functionality" {
        BeforeAll {
            $Title = "Test Title"
            $Date = Get-Date -Format %d
            $Today = Get-Date
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


