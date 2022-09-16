$PSVersionTable.PSVersion
$host 
Get-Host
Get-HotFix
Get-PSReadLineKeyHandler

get-aduser

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

Get-Command -Module * | measure