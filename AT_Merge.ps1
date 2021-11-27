New-Item -ItemType "directory" -Path "c:\Patching\Merge" -Force
New-Item -ItemType "directory" -Path "c:\Patching\Report" -Force
New-Item -ItemType "directory" -Path "c:\Patching\Archive" -Force

get-childitem -Path "\\LAPTOP-T6UBO1E1\C`$\automation\*_installed.csv" |
    where-object {$_.LastWriteTime -le (get-date).AddDays(-0)} | 
    copy-item -destination C:\Patching\Report

$pathin = 'c:\patching\report'
$pathout = 'c:patching\Merge\merged.csv'
$list = Get-ChildItem -Path $pathin | select FullName
foreach($file in $list){
    Import-Csv -Path $file.FullName | Export-Csv -Path $pathout -Append -NoTypeInformation
}

# Compress-Archive -Path C:\Patching\Merge\merged.csv -DestinationPath C:\Patching\Archive\*.zip
# Get-ChildItem -Path C:\Patching\Merge\merged.csv |
#   Compress-Archive -DestinationPath C:\Patching\Archive\"PatchArchive-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))".zip
# Remove-Item C:\Patching\report\merged.csv

# $Folder = "C:\Patching\Report"
# Get-ChildItem $Folder -Recurse -Force -ea 0 |
# ? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-100)} |
# ForEach-Object {
#   $_ | del -Force
#   $_.FullName | Out-File C:\Patching\deletedlog.txt -Append
# }


Copy-Item C:\Patching\Archive\Patch*.zip -Destination \\LAPTOP-T6UBO1E1\C`$\automation