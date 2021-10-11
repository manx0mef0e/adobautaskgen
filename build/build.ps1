[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $ResolveDependency,

    [Parameter(Mandatory = $true)]
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
        Path = $ModuleDependsFilePath
        Import = $true
        Install = $true
        Confirm = $false
    }

    Invoke-PSDepend @InvokePSDependArgs
}

Write-Host "`nSTARTED TASK: Set build variables"
Set-BuildEnvironment -Force

Write-Host "`nSTARTED TASK: $Task"
$InvokePsakeArgs = @{
    buildFile = Join-Path $PSScriptRoot -ChildPath "psakeFile.ps1"
    nologo = $true
    tasklist = $Task
}
Invoke-Psake @InvokePsakeArgs

Write-Host "`nFINISHED TASKS"
