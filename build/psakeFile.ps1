Properties {
    $Lines = "----------------------------------------------------------------------"
    $UnitTestsFolder = Join-Path -Path $ENV:BHProjectPath -ChildPath "Tests" -AdditionalChildPath "Unit-Tests"
}

Task Init {
    $Lines

    Set-Location $ENV:BHProjectPath
    Write-Host "Build system details"
    Get-Item ENV:BH*
}

Task UnitTests -Depends Init {
    $Lines

    $Config = [PesterConfiguration]@{
        Run = @{
            Path = $UnitTestsFolder
            PassThru = $true
        }
        CodeCoverage = @{
            Enabled = $true
            OutputFormat = "JaCoCo"
            OutputPath = Join-Path -Path $ENV:BHProjectPath -ChildPath "TestResults" -AdditionalChildPath "codeCoverage.xml"
            Path = @(
                (Join-Path -Path $ENV:BHModulePath -ChildPath Private)
                (Join-Path -Path $ENV:BHModulePath -ChildPath Public)
            )
        }
        TestResult = @{
            Enabled = $true
            OutputFormat = "JUnitXml"
            OutputPath = Join-Path -Path $ENV:BHProjectPath -ChildPath "TestResults" -AdditionalChildPath "pesterTests.xml"
        }
        Output = @{
            Verbosity = "Detailed"
        }
    }
    $PesterResults = Invoke-Pester -Configuration $Config

    if ($PesterResults.FailedCount -gt 0) {
        Write-Host "$($PesterResults.FailedCount) failed unit tests, build cannot continue."
        $TestFailure = $true
    }

    $Coverage = [math]::Round($(100 - (($PesterResults.CodeCoverage.CommandsMissedCount / $PesterResults.CodeCoverage.CommandsAnalyzedCount) * 100)), 2);

    if ($Coverage -lt 75) {
        Write-Host "Code coverage is $Coverage%. Minimum requirement is 75, build cannot continue."
        $TestFailure = $true
    }

    if ($TestFailure) {
        exit 1
    }

}

Task BumpVersion -Depends Init {
    $Lines

    npm install -g standard-version
    git config --global user.email "build@fakeemail.com"
    git config --global user.name "buildbot"
    standard-version

    $PackageJsonPath = Join-Path -Path $ENV:BHProjectPath -ChildPath "package.json"
    $PackageJson = Get-Content -Path $PackageJsonPath | ConvertFrom-Json
    $ProjectVersion = $PackageJson.version
    Update-ModuleManifest -Path $ENV:BHPSModuleManifest -ModuleVersion $ProjectVersion
}

Task CreateExternalHelpFile {}

Task CombineFunctions {}

Task Publish {}
