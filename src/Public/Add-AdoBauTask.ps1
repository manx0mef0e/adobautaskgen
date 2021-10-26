function Add-AdoBauTask {
    [CmdletBinding(DefaultParameterSetName = "Frequency")]
    param (
        [Parameter(Mandatory = $true,ParameterSetName = "Frequency")]
        [Parameter(Mandatory = $true,ParameterSetName = "Specific")]
        [string]
        $Title,

        [Parameter(Mandatory = $true,ParameterSetName = "Frequency")]
        [Parameter(Mandatory = $true,ParameterSetName = "Specific")]
        [string]
        $Description,

        [Parameter(Mandatory = $true,ParameterSetName = "Frequency")]
        [Parameter(Mandatory = $true,ParameterSetName = "Specific")]
        [int]
        $ParentId,

        [Parameter(Mandatory = $true,ParameterSetName = "Frequency")]
        [ValidateSet("Daily","Weekly","Monthly","Quarterly","Half-Yearly","Yearly")]
        [string]
        $Frequency,

        [Parameter(Mandatory = $true,ParameterSetName = "Specific")]
        [int]
        $RunDate
    )

    $ParentTask = Get-VSTeamWorkItem -Id $ParentId
    $AreaPath = $ParentTask.AreaPath
    $IterationPath = $ParentTask.IterationPath
    $ProjectName = $ParentTask.TeamProject

    $HtmlDescription = ConvertFrom-MarkdownToHtml -Markdown $Description

    $GetFullTitleArgs = @{ Title = $Title }

    if ($RunDate) {
        $GetFullTitleArgs.RunDate = $RunDate
    }
    else {
        $GetFullTitleArgs.Frequency = $Frequency
    }

    $FullTitle = Get-FullTitle @GetFullTitleArgs

    $AddVSTeamWorkItemArgs = @{
        Title = $FullTitle
        Description = $HtmlDescription
        IterationPath = $IterationPath
        AdditionalFields = @{
            "System.AreaPath" = $AreaPath
        }
        ParentId = $ParentId
        WorkItemType = "Task"
        ProjectName = $ProjectName
    }
    Add-VSTeamWorkItem @AddVSTeamWorkItemArgs
}
