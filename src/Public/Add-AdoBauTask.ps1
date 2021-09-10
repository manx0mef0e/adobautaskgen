function Add-AdoBauTask {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Title,
        
        [Parameter()]
        [string]
        $Description,

        [Parameter(Mandatory)]
        [int]
        $ParentId
    )

$ParentTask = Get-VSTeamWorkItem -Id $ParentId
$AreaPath = $ParentTask.AreaPath
$IterationPath = $ParentTask.IterationPath
}
