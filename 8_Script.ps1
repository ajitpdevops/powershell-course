$files = ls .\input 

$files | ForEach-Object { 
    
    $noOfLines = (Get-Content $_.FullName ).Length
    $_ | Add-Member -NotePropertyMembers @{ LineCount = $noOfLines } 

}

$files | Format-Table -Property @('Name', 'FullName', 'Linecount')

# Conting the number of lines 
# (Get-Content .\input\students.csv).GetType()
# (Get-Content .\input\students.csv).Length