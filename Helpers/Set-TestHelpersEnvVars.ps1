param (
    $Path
)

Set-BuildEnvironment -Path ($Path -replace "Tests.+" -replace "Tools") -Force
$ENV:THFunctionName = (Get-Item -Path $Path).BaseName -replace "\.tests"
$ENV:THFunctionPath = $Path -replace ".+Unit-Tests",$ENV:BHPSModulePath -replace "\.tests"