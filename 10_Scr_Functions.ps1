function Get-ReturnMessage {
    # Adding the CmdletBinding attribute to the function leads to the function correctly writing to the verbose stream
    [cmdletBinding()]
    param (
        [String]$Message
    )

    Write-Verbose "We are going to write the message by the user"
    Write-Output $message
}

function Get-Function {
    [CmdletBinding()]
    param ()
    
    $ErrorActionPreference
    Get-CimInstance -ClassName "FakeClass"

    Write-Host "Let's do something else"
    Write-Host 2+2
    
}

Simple-Function
# The ErrorAction switch in combination with the “Stop” option leads to PowerShell terminating execution when encountering an error
Simple-Function -ErrorAction Stop

function Get-NewReturnMessage {
    [cmdletBinding()]
    param (
        #Mandatory Param
        [Parameter(Mandatory)][String] $Message
    )
    Write-Output $Message
}

Get-NewReturnMessage

function FunctionName {
    param (
        OptionalParameters
    )
    
}