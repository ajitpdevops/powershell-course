Write-Output 'Please enter the first number'
$first = [int](Read-Host)

Write-Output 'Please enter the second number'
$second =[int](Read-Host)

$result = ($first + $second)

Write-Output "The sum is $result" 