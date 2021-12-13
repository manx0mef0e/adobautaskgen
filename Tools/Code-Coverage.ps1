Set-BuildEnvironment -Force

$UnitTestsFolder = Join-Path -Path $ENV:BHProjectPath -ChildPath "Tests" -AdditionalChildPath "Unit-Tests"

$Config = [PesterConfiguration]@{
    Run = @{
        Path = $UnitTestsFolder
        PassThru = $true
    }
    CodeCoverage = @{
        Enabled = $true
        Path = @(
            (Join-Path -Path $ENV:BHModulePath -ChildPath Private)
            (Join-Path -Path $ENV:BHModulePath -ChildPath Public)
        )
    }
    Output = @{
        Verbosity = "Detailed"
    }
}

$PesterResults = Invoke-Pester -Configuration $Config

$Coverage = [math]::Round($PesterResults.CodeCoverage.CoveragePercent)

$PesterResults.CodeCoverage.CommandsMissed

Write-Host "Code Coverage $Coverage%, $($PesterResults.CodeCoverage.CommandsMissedCount) missed"
