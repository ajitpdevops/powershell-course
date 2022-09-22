# pipeline

"server1","server2" | Test-NetConnection
get-Vm | Enable-VMResourceMetering
Get-ComputerInfo | ConvertTo-Html | Out-File reports.html

# Get member 

get-service WlanSvc | Get-Member
(get-service WlanSvc).status   
$svcdtl = get-service WlanSvc
$svcdtl.Status


# Formatting

Get-Service *Print* | Format-Table Status, Name, DisplayName
Get-Service *Print* | Format-Table Status, Name, DisplayName -AutoSize

Get-Service *Print* | Format-Wide Name