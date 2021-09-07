param (
    $Path
)

$BuildHelperVars = Get-Item env:BH*
if (!$BuildHelperVars) {
    Set-BuildEnvironment -Path ($Path -replace "Tests.+")
}
