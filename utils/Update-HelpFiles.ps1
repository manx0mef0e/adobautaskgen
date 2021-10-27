[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [System.IO.FileInfo]
    $SourceFolder,

    [Parameter(Mandatory = $true)]
    [String]
    $ModuleName,

    [Parameter(Mandatory = $true)]
    [System.IO.FileInfo]
    $DocsPath
)

$ManifestPath = Join-Path -Path $SourceFolder -ChildPath "$ModuleName.psd1"
Import-Module -Name $ManifestPath

Update-MarkdownHelp -Path $DocsPath
