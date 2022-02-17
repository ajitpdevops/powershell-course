get-process | Where-Object {$_.CPU -gt 20 } | Select-object Name, SI, Handles, NPM, CPU | Export-CSV .\input\test.csv

$students = Import-Csv .\input\students.csv
$students | ForEach-Object {$_.Math = [int]$_.Math}
$students | ForEach-Object {$_.English = [int]$_.English}
$students | ForEach-Object {$_.Math} | Measure-Object -Average


$processes = Import-Csv '.\input\test.csv'
$processes | ForEach-Object {$_.CPU = [int]$_.CPU}
$processes | ForEach-Object {$_.CPU} | Measure-Object -Average

# Adding a NoteProperty to object 
$file = Get-ChildItem .\input | Where-Object {$_.Name -eq 'test.csv'}
Add-Member -InputObject $file -MemberType NoteProperty -Name 'Importance' -Value 0
$file.GetType()
$file | Format-Table -Property Name, Length, Importance
$file.Importance = 5

#Adding a property 
$students | ForEach-Object { Add-Member -InputObject $_ -MemberType NoteProperty -Name 'Sum' -Value ($_.Math + $_.English)}
$students | ForEach-Object {$_ | Add-Member -NotePropertyMembers @{ Sum = ($_.Math + $_.English) } }

$students | Export-Csv .\input\students_1.csv

[string]

$s = 'Ajit'
$s.Length
$file 
$file.GetType().GetProperties()
$file.GetType().GetProperties() | Format-Table

get-process | % {$_.GetType()} 

#Move Method 
$file1 = Get-ChildItem .\newnotes.txt
$file1.MoveTo('devops_notes.txt')

#Replace Method 
$s.Replace('Ajit', 'Anvi')
$s
'A,B'.Replace(',', ':')

Get-Process | Get-Member

# Start                     Method        void Start(), void Start(string[] args)
# Method Overloading 


Get-Command [G-L]*

get-service wu*

Write-Warning "Test Warning"

Get-ExecutionPolicy 
Get-ExecutionPolicy -List

Compare-Object -ReferenceObject (gc .\input\students.csv) -DifferenceObject (gc -Path .\input\students_1.csv)

Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope LocalMachine