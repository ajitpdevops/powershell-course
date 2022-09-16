$serverName = 'localhost'
$script = try {
    write-host 'Test Script'
}
catch {
    Write-Error "Could not write"
}
Invoke-Command -ComputerName $serverName -ScriptBlock $script


Get-WmiObject -Class Win32_Process | Select-Object -First 5 | Format-Table
(Get-WmiObject -Class Win32_Service -Filter "name='AdobeARMservice'").Status

Get-WmiObject -Class Win32_BIOS | Format-List -Property *