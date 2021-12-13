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
        BeforeEach {
            Mock Get-VSTeamWorkItem {
                return @{
                    AreaPath = "MockAreaPath"
                    IterationPath = "MockIterationPath"
                    ProjectName = "MockProjectName"
                }
            }
            Mock ConvertFrom-MarkdownToHtml {
                return "MockHtmlDescription"
            }
            Mock Get-FullTitle {
                return "MockTitle"
            }
            Mock Add-VSTeamWorkItem

            Add-AdoBauTask -Title "Title" -Description "Description" -ParentID 69 -Frequency "Daily"
        }

        It "Gets the work item details" {
            Should -Invoke -CommandName Get-VSTeamWorkItem
        }

        It "Should convert Markdown to HTML" {
            Should -Invoke -CommandName ConvertFrom-MarkdownToHtml
        }

        It "Should get the Full Title" {
            Should -Invoke -CommandName Get-FullTitle
        }

        It "Should create a new task" {
            Should -Invoke -CommandName Add-VSTeamWorkItem
        }

    }

    Context "Task creation with set run date" {
        BeforeEach {
            Mock Get-VSTeamWorkItem {
                return @{
                    AreaPath = "MockAreaPath"
                    IterationPath = "MockIterationPath"
                    ProjectName = "MockProjectName"
                }
            }
            Mock ConvertFrom-MarkdownToHtml {
                return "MockHtmlDescription"
            }
            Mock Get-FullTitle {
                return "MockTitle"
            }
            Mock Add-VSTeamWorkItem

            Add-AdoBauTask -Title "Title" -Description "Description" -ParentID 69 -RunDate 10
        }

        It "Uses the specific run date in setting task name" {
            Should -Invoke -CommandName Get-FullTitle -ParameterFilter {$RunDate -eq 10}
        }
    }

}
