Task Init {
    Set-Location $ENV:BHProjectPath
    Write-Host "Build system details"
    Get-Item ENV:BH*
}

Task UnitTests {}

Task CreateExternalFile {}

Task CombineFunctions {}

Task BumpVersion {}

Task Publish {}
