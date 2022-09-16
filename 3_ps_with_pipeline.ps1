#pipeline
"server1","server2" | Test-NetConnection
get-Vm | Enable-VMResourceMetering
Get-ComputerInfo | ConvertTo-Html | Out-File reports.html

# Get member 

get-service WlanSvc | Get-Member

(get-service WlanSvc).status   
$svcdtl = get-service WlanSvc
$svcdtl.Status