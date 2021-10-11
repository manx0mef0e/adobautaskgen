function Get-FullTitle {
    [CmdletBinding(DefaultParameterSetName = "Frequency")]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Frequency")]
        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [string]
        $Title,

        [Parameter(Mandatory = $true, ParameterSetName = "Frequency")]
        [ValidateSet("Daily","Weekly","Monthly","Quarterly","Half-Yearly","Yearly")]
        [string]
        $Frequency,

        [Parameter(Mandatory = $true, ParameterSetName = "Specific")]
        [int]
        $RunDate
    )

    $Today = Get-Date

    if ($RunDate) {
        $CompleteTitle ="$RunDate $(Get-Date $Today -UFormat %b): $Title"
    }
    elseif ($Frequency -eq "Daily") {
        $CompleteTitle = "$($Today.DayOfWeek): $Title"
    }
    elseif ($Frequency -eq "Weekly") {
        $CompleteTitle ="Week $(Get-Date $Today -UFormat %V): $Title"
    }
    elseif ($Frequency -eq "Monthly") {
        $CompleteTitle ="$(Get-Date $Today -UFormat %B): $Title"
    }
    elseif ($Frequency -eq "Quarterly") {
        $CompleteTitle ="Q$([math]::Ceiling($Today.Month / 3)): $Title"
    }
    elseif ($Frequency -eq "Half-Yearly") {
        $CompleteTitle ="H$([math]::Ceiling($Today.Month / 6)): $Title"
    }
    elseif ($Frequency -eq "Yearly") {
        $CompleteTitle ="$($Today.Year): $Title"
    }
    else {
        throw "Cannot create title based on frequency"
    }

    return $CompleteTitle
}
