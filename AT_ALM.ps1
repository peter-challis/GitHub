# Create date stamp folder 
$path = "ALMlogs-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))"
New-Item -ItemType "directory" -Path c:\ALM\"$path"