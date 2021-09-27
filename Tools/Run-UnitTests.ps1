# This will run Pester Unit Tests
$BuildVarModuleFilePath = Join-Path -Path ($PSScriptRoot -replace "Tools") -ChildPath "Helpers" -AdditionalChildPath "Set-TestHelpersEnvVars.ps1"
. $BuildVarModuleFilePath -Path $PSScriptRoot

$UnitTestPath = Join-Path -Path ($PSScriptRoot -replace "Tools") -ChildPath "Tests" -AdditionalChildPath "Unit-Tests"

Invoke-Pester -Path $UnitTestPath -Output Detailed
