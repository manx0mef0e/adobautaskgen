# This will run via PScriptAnalyzer on the module files.
$BuildVarModuleFilePath = Join-Path -Path ($PSScriptRoot -replace "Tools") -ChildPath "Helpers" -ChildPath "Set-TestHelpersEnvVars.ps1"
. $BuildVarModuleFilePath -Path $PSScriptRoot

$Result = Invoke-ScriptAnalyzer -Path $ENV:BHPSModulePath -Severity @("Error","Warning") -Recurse

if ($Result) {
    $Result | Format-Table
}