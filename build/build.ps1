[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $ResolveDependency,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Init","UnitTests","BumpVersion","CreateStagingFolder","CreateExternalHelpFile","CombineFunctions","Publish")]
    [string]
    $Task
)

if ($ResolveDependency.IsPresent) {
    Write-Host "`nSTARTED TASK: Install Dependencies"

    if (-not ((Get-PSRepository "PSGallery").InstallationPolicy -like "Trusted")) {
        Write-Host "`n  Setting PSGallery as a trusted source"
        Set-PSRepository "PSGallery" -InstallationPolicy "Trusted"
    }

    Get-PackageProvider -Name "NuGet" -ForceBootstrap | Out-Null

    if (-not (Get-Module "PSDepend" -ListAvailable)) {
        Write-Host "`n  Installing PSDepend module"
        Install-Module "PSDepend" -Scope CurrentUser -Force
    }

    $ModuleDependsFilePath = Join-Path $PSScriptRoot -ChildPath "requirements.psd1"

    Write-Host "`n  Resolving dependancies from $ModuleDependsFilePath"
    $InvokePSDependArgs = @{
        Path    = $ModuleDependsFilePath
        Import  = $false
        Install = $true
        Confirm = $false
    }

    Invoke-PSDepend @InvokePSDependArgs
}

Write-Host "`nSTARTED TASK: Set build variables"
Import-Module -Name BuildHelpers
Set-BuildEnvironment -Force

Write-Host "`nSTARTED TASK: $Task"
Import-Module psake
$InvokePsakeArgs = @{
    buildFile = Join-Path $PSScriptRoot -ChildPath "psakeFile.ps1"
    nologo    = $true
    tasklist  = $Task
}
Invoke-Psake @InvokePsakeArgs

Write-Host "`nFINISHED TASKS"
