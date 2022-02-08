function ConvertFrom-MarkdownToHtml {
    [OutputType("System.String")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Markdown
    )

    $Uri = "https://api.github.com/markdown"

    $ApiRequestBody = @{
        text = $Markdown
        mode = "markdown"
    }

    $Response = Invoke-WebRequest -Uri $Uri -Method Post -Body ($ApiRequestBody | ConvertTo-Json)


    if ($Response.StatusCode -eq 200) {
        return $Response.Content
    }
    else {
        return $Markdown
    }
}
