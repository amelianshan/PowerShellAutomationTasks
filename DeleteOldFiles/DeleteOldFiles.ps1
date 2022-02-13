# Delete all Files(No folder) in D:\ older than 90 day(s)
$Path = "D:\"
$Daysback = "-90"
 
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
Get-ChildItem -File $Path -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } 
