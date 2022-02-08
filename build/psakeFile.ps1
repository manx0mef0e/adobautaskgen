Properties {
    $Lines = "----------------------------------------------------------------------"
    $UnitTestsFolder = Join-Path -Path $ENV:BHProjectPath -ChildPath "Tests" -AdditionalChildPath "Unit-Tests"
    $StagingFolder = Join-Path -Path $ENV:BHProjectPath -ChildPath "staging"
    $StagingModulePath = Join-Path -Path $StagingFolder -ChildPath $ENV:BHProjectName
}

Task Init {
    $Lines

    Set-Location $ENV:BHProjectPath
    Write-Host "Build system details"
    Get-Item ENV:BH*
}
# TODO: Linting
Task UnitTests -Depends Init {
    $Lines

    Import-Module -Name Pester

    $Config = [PesterConfiguration]@{
        Run          = @{
            Path     = $UnitTestsFolder
            PassThru = $true
        }
        CodeCoverage = @{
            Enabled      = $true
            OutputFormat = "JaCoCo"
            OutputPath   = Join-Path -Path $ENV:BHProjectPath -ChildPath "TestResults" -AdditionalChildPath "codeCoverage.xml"
            Path         = @(
                (Join-Path -Path $ENV:BHModulePath -ChildPath Private)
                (Join-Path -Path $ENV:BHModulePath -ChildPath Public)
            )
        }
        TestResult   = @{
            Enabled      = $true
            OutputFormat = "JUnitXml"
            OutputPath   = Join-Path -Path $ENV:BHProjectPath -ChildPath "TestResults" -AdditionalChildPath "pesterTests.xml"
        }
        Output       = @{
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

    Remove-Module -Name Pester
}

Task BumpVersion -Depends Init {
    $Lines

    npm install -g standard-version
    git config --global user.email "$ENV:gitUserEmail"
    git config --global user.name "$ENV:gitUserName"
    standard-version

    $PackageJsonPath = Join-Path -Path $ENV:BHProjectPath -ChildPath "package.json"
    $PackageJson = Get-Content -Path $PackageJsonPath | ConvertFrom-Json
    $ProjectVersion = $PackageJson.version
    Update-ModuleManifest -Path $ENV:BHPSModuleManifest -ModuleVersion $ProjectVersion

    $PackageLockJsonPath = Join-Path -Path $ENV:BHProjectPath -ChildPath "package-lock.json"
    $ChangeLogPath = Join-Path -Path $ENV:BHProjectPath -ChildPath "CHANGELOG.md"
    git add $PackageJsonPath
    git add $ENV:BHPSModuleManifest
    git add $PackageLockJsonPath
    git add $ChangeLogPath

    $CommitMessage = "chore(release): $ProjectVersion [skip ci]"
    git commit -m $CommitMessage
    git tag -a v$ProjectVersion -m $CommitMessage
    git push --follow-tags

}

Task CreateStagingFolder -Depends Init {
    $Lines

    New-Item -Path $StagingFolder -ItemType Directory -Force | Out-String
    New-Item -Path $StagingModulePath -ItemType Directory -Force  | Out-String
}

Task CreateExternalHelpFile -Depends CreateStagingFolder {
    $Lines

    Import-Module -Name platyPS

    $NewExternalHelpArgs = @{
        Path       = Join-Path -Path $ENV:BHProjectPath -ChildPath "docs"
        OutputPath = Join-Path -Path $StagingModulePath -ChildPath "en-US"
    }
    New-ExternalHelp @NewExternalHelpArgs

    Remove-Module -Name platyPS
}

Task CombineFunctions -Depends CreateStagingFolder {
    $Lines

    $ClassesFolder = Join-Path -Path $ENV:BHModulePath -ChildPath "Classes" -AdditionalChildPath "*.ps1"
    $Classes = @(Get-ChildItem -Path $ClassesFolder -ErrorAction SilentlyContinue)

    $PrivateFolder = Join-Path -Path $ENV:BHModulePath -ChildPath "Private" -AdditionalChildPath "*.ps1"
    $PrivateFuncs = @(Get-ChildItem -Path $PrivateFolder -ErrorAction SilentlyContinue)

    $PublicFolder = Join-Path -Path $ENV:BHModulePath -ChildPath "Public" -AdditionalChildPath "*.ps1"
    $PublicFuncs = @(Get-ChildItem -Path $PublicFolder -ErrorAction SilentlyContinue)

    $CombinedModulePath = Join-Path -Path $StagingModulePath -ChildPath "$ENV:BHProjectName.psm1"

    if (Test-Path -Path $CombinedModulePath) {
        Remove-Item $CombinedModulePath
    }

    foreach ($file in @($Classes + $PrivateFuncs + $PublicFuncs)) {
        $file | Get-Content | Add-Content -Path $CombinedModulePath
    }

    Copy-Item -Path $ENV:BHPSModuleManifest -Destination $StagingModulePath -Force
}

Task Publish -Depends Init {
    $Lines

    Import-Module -Name PSDeploy

    $ENV:StagingModulePath = $StagingModulePath

    $InvokePSDeployArgs = @{
        Path    = Join-Path -Path $ENV:BHProjectPath -ChildPath "build"
        Force   = $true
        Recurse = $true
    }
    Invoke-PSDeploy @InvokePSDeployArgs
}
