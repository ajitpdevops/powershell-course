<#
.SYNOPSIS
    Returns your public IP address.
.DESCRIPTION
    Queries the ipify Public IP Address API and returns your public IP.
.EXAMPLE
    Get-PublicIP
 
    Returns the public IP.
.OUTPUTS
    System.String
.NOTES
    https://github.com/rdegges/ipify-api
#>

function Get-PublicIP {
    [CmdletBinding()]
    param (
    )
    $uri = 'https://api.ipify.org'
    Write-Verbose -Message "Pullling the IP from $uri"
    try {
        $invokeRestMethodSplat = @{
            Uri         = $uri
            ErrorAction = 'Stop'
        }
        $publicIP = Invoke-RestMethod @invokeRestMethodSplat
    }
    catch {
        Write-Error $_
    }

    return $publicIP
}