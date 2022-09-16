Get-ComputerInfo
Get-Windowsfeature

# add / remove / rename in domain 
Add-Computer
Remove-Computer
Rename-Computer
Restart-Computer
Restart-Computer -ComputerName server1 -Wait -For PowerShell ; Write-Host "Done"

Test-ComputerSecureChannel  #check trust relationship between computer and domain.
Test-ComputerSecureChannel -Repair

Get-Date
Get-TimeZone

# Networking 
Get-NetIPAddress
Get-NetAdapterStatistics
Get-DnsClient
Get-DnsClientServerAddress
Get-NetFirewallRule # check firewall rules 

ping google.com # This still works 
Test-Connection google.com # This is old way of pinging but returns an error if fails
Test-NetConnection # Verifies the internet connection 
Test-NetConnection google.com
Test-NetConnection google.com -TraceRoute
Test-NetConnection google.com -Port 80
Resolve-DnsName www.microsoft.com # equicalent to DNSlookup or dig in linux 

# Hyper-V
Get-/Set-VM 
New-VM
Start-/Stop-/Restart-/Suspend-/Resume-/Checkpoint-VM
Enable-VMResourceMetering/Measure-VM

Get-VM | Checkpoint-VM
Get-VM | Enable-VMResourceMetering
Get-VM | Measure-VM
Invoke-Command list { get-VM | measure-VM }

# Comparision Operators in powershell 
# -eq, -ne, -gt, -lt, -ge, -le, -like, -notlike 
# use c infornt of the operator to enforce case sensitivity 

5 -eq 4
5 -gt 4 
"test" -like "something"
"test" -like "tes*"
"TEST" -clike "tes*"  #case sensitivity 


# Active Directory 
Get-WindowsCapability -Online -Name RSAT*
Add-WindowsCapability -Online -Name rsat.ActiveDirectory.DS-LDS 
search-ADAccount -AccountDisabled
search-ADAccount -Lockedout 
search-ADAccount -PasswordNeverExpires 

get-aduser -Identity idnajp
get-aduser idnajp
get-aduser -Identity idnajp -Properties *

Get-ADUser -Filter * -SearchBase "OU=QA,DC=ideasdev,DC=int"
Get-ADUser -Filter * -SearchBase "OU=QA,DC=ideasdev,DC=int" -Properties LastLogonDate, Department | Format-Table Name, LastLogonDate, Department

Get-ADUser -Filter {Department -eq 'Marketing'-or Department -eq 'sales' or Department -like '*I*'}

set-adAccountpassword Lara -Newpassword (Read-Host -AsSecureString )

set-ADUser Lara -Add @{carLicense='ABCD123'}
get-AdUser Lara -Properties carLicense

Get-Command -Module * | measure

