[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Suppress false positives in BeforeAll scriptblock')]
param()

$BuildVarModuleFilePath = Join-Path -Path ($PSScriptRoot -replace "Tests.+") -ChildPath "Helpers" -AdditionalChildPath "Set-TestHelpersEnvVars.ps1"
. $BuildVarModuleFilePath -Path $PSScriptRoot

Describe "$ENV:BHProjectName Manifest" {
    BeforeAll {
        $ManifestPath = $ENV:BHPSModuleManifest
        $ModuleName = $ENV:BHProjectName
        $ModulePath = $ENV:BHPSModulePath

        $ManifestObject = Import-PowerShellDataFile -Path $ManifestPath
    }

    It "Has a valid manifest" {
        {
            $null = Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop -WarningAction SilentlyContinue
        } | Should -Not -Throw 
    }

    It "Has a valid root module" {
        $ManifestObject.RootModule | Should -Be "$ModuleName.psm1"
    }

    It "Has a valid description" {
        $ManifestObject.Description | Should -Not -BeNullOrEmpty 
    }

    It "Has a valid GUID" {
        $ManifestObject.GUID | Should -Be "099a5f22-bd58-4182-b0b0-212e75551c3f"
    }

    It "Has a version number that matches semver" {
        $VersionNumber = $ManifestObject.ModuleVersion
        $VersionNumber -match "^\d+\.\d+\.\d+$" | Should -Be $true
    }

    It "Exports all public functions" {
        $PublicFolder = Join-Path -Path $ModulePath -ChildPath Public
        $PublicFunctions = Get-ChildItem -Path $PublicFolder -Filter *.ps1 | Select-Object -ExpandProperty Basename
        $ExportedFunctions = $ManifestObject.FunctionsToExport
        
        if ($PublicFunctions) {
            foreach ($Function in $PublicFunctions) {
                $ExportedFunctions -contains $Function | Should -Be $true                
            }
        }
        else {
            $ExportedFunctions | Should -BeNullOrEmpty
        }

    }

}
