<#
.SYNOPSIS
    Returns weather report information.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>

function Get-Wheather {
    [CmdletBinding()]
    param (

        [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [string]
        $City,

        [Parameter(Position = 1)]
        [ValidateSet('Metric', 'USCS')]
        [string]
        $Units = 'USCS',

        [Parameter(Position = 2)]
        [ValidateSet('ar', 'af', 'be', 'ca', 'da', 'de', 'el', 'en', 'et', 'fr', 'fa', 'hu', 'ia', 'id', 'it', 'nb', 'nl', 'pl', 'pt-br', 'ro', 'ru', 'tr', 'th', 'uk', 'vi', 'zh-cn', 'zh-tw')]
        [string]
        $Language = 'en',

        [Parameter(Position = 3)]
        [switch]
        $Short
    )
    
    $uriString = 'https://wttr.in/'

    if ($City) {
        $uriString += "$City"
    }

    switch ($Units) {
        'Metric' { 
            $uriString += "?m"
         }
        'USCS' {
            $uriString += "?u"
        }
    }

    if ($Short) {
        $uriString += "&format=4"
    }

    $uriString += "&lang=$Language"

    Write-Verbose "URI: $uriString"

    $invokesplat = @{
        Uri     = $uriString
        ErrorAction = 'Stop'
    }

    try {
        Invoke-RestMethod @invokesplat
    }
    catch {
        Write-Error $_
    }
}