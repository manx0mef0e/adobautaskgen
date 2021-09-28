function Get-FullTitle {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Title,

        [Parameter(Mandatory)]
        [ValidateSet("Daily","Weekly","Monthly","Quarterly","Half-Yearly","Yearly","Specific")]
        [string]
        $Frequency,

        [Parameter()]
        [int]
        $RunDate
    )

    $Today = Get-Date

    if ($Frequency -eq "Daily") {
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
    elseif ($Frequency -eq "Specific" -and $RunDate) {
        $CompleteTitle ="$RunDate $(Get-Date $Today -UFormat %b): $Title"
    }
    else {
        throw "Cannot create title based on frequency"
    }

    return $CompleteTitle
}
