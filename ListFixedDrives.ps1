
[System.IO.DriveInfo]::getdrives() | Where-Object {$_.DriveType -eq 'Fixed'} | export-csv -Path ‘c:\FixedDrives.csv’ -NoTypeInformation
$users=Import-Csv C:\FixedDrives.csv
$users[0].name | Out-file C:\FixedPassed.txt

