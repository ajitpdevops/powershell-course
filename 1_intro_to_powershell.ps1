$PSVersionTable.PSVersion
$host 
Get-Host
Get-HotFix
Get-PSReadLineKeyHandler

get-aduser
Get-ChildItem | Measure-Object | Format-Table

Get-Service -Name wuauserv
Get-Service -Name wuauserv,wsearch
Get-Process | 
get-process powershell

Get-Help Get-Service
help Get-Service
Get-Help Get-Service -Full
help Get-Service -ShowWindow
help about*


Get-Command *user*
Get-Command *user* -Module ActiveDirectory
Get-Command *user* -CommandType Application

Find-Command 
Find-Command -Tag NTFS
Show-Command

Get-Module
Get-Module -ListAvailable
Find-Module Az
Find-Module Az -AllVersions

Get-ChildItem | Where-Object {$_.Extension -eq '.md'}
Get-Process | Where-Object  {$_.CPU -gt 20 } | Measure-Object
Get-Process | Where-Object  {$_.CPU -gt 20 } | Sort-Object {$_.Id}

Get-ChildItem | ForEach-Object {$_.Length} | Measure-Object -Average

(Get-Process | Where-Object {$_.id -gt 4000} | ForEach-Object {$_.CPU} | Measure-Object -Average).Average

Get-PSDrive

Get-Command *user*