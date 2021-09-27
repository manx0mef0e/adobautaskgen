function ConvertFrom-MarkdownToHtml {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Markdown
    )

    $Uri = "https://api.github.com/markdown"
    $ApiRequestBody = New-Object -TypeName PSObject
    $ApiRequestBody | Add-Member -MemberType NoteProperty -Name text -Value $Markdown
    $ApiRequestBody | Add-Member -MemberType NoteProperty -Name mode -Value "markdown"

    $Response = Invoke-WebRequest -Uri $Uri -Method Post -Body ($ApiRequestBody | ConvertTo-Json)


    if ($Response.StatusCode -eq 200) {
        return $Response.Content
    }
    else {
        return $Markdown
    }
}
