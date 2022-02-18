Write-Output 'Please enter you ip address'
$ipaddr = Read-Host

Write-Output " This is your IP: $ipaddr"

# [ValidatePattern("[2][9][0-9][0-9[[0-9]")] [String]

$a = [PSCustomObject]@{
    p = 5
}

$a.GetType()