function Set-AdoConnection {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]
        $Url,

        [Parameter(Mandatory)]
        [string]
        $Project,

        [Parameter(Mandatory)]
        [string]
        $PersonalAccessToken
    )

    if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
        Set-VSTeamAccount -Account $Url -PersonalAccessToken $PersonalAccessToken
        Set-VSTeamDefaultProject -Project $Project
    }
}
