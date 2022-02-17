$num = 3
$num + 2 
$num += 2

$num.GetType()
$false 

[bool].IsPrimitive

$name = 'Ajit'
'Hello $name'
"Hello $name"
$age = 40
"Hello my name is $name, I am $($age - 5) years old"
$str = 'abc'
$str += '.'
$str
$str + '15'
$str

# Create a stringbuilder
[System.Text.StringBuilder]::new()
$sb = [System.Text.StringBuilder]::new()
$sb.GetType()

# Create a datetime object 
[datetime]::new(1988, 5,26)
New-Object -TypeName datetime

# Create an array
@('Alex', 'Mike', 'John')
$names = {'Ajit', 'Amit', 'Anil'} 

$arr = @('Alex', 'Mike', 'John')
$arr.GetType()
$arr.Length
$arr[2]

$arr | % {$_ + '.'}

($arr | % {$_ + '.'}).GetType()

(Get-Process).GetType()
(Get-Process)[0]
(Get-Process).Length

$str = 'abc'
$str[1]
$str[1].GetType()

$arr += 'Tom'
$arr