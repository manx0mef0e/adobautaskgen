param (
    $Path
)

Set-BuildEnvironment -Path ($Path -replace "Tests.+" -replace "Tools") -Force
