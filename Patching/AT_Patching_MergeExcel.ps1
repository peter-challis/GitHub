# Create new folders and over write if exists
# New-Item -Path c:\PostPatching -ItemType directory -force

New-Item -ItemType "directory" -Path "c:\PostPatching" -force
New-Item -ItemType "directory" -Path "c:\PostPatching\Reports"
New-Item -Path "c:\PostPatching" -Name "archive" -ItemType "directory"

# Create date stamp folder for imports from endpoints
# $path = "InstalledPatches-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))"
# New-Item -ItemType Directory -Path $path
# New-Item -ItemType "directory" -Path c:\PostPatching\"$path"

# Note the patching report will have the same name each month.  That file will be pulled from the endpoint on to the SFS, overwritting last months csv

# copy *_installed.csv file no older than x days from remote SFS server to csv rep on WSUS
get-childitem -Path "\\LAPTOP-T6UBO1E1\C`$\automation" |
    where-object {$_.LastWriteTime -le (get-date).AddDays(-10)} | 
    copy-item -destination c:\PostPatching

# merge all .csv files into one
# Get-ChildItem -Filter $path\*.csv | Select-Object -ExpandProperty FullName | Import-Csv | Export-Csv .\"CombinedPatches-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))".csv -NoTypeInformation -Append
Get-ChildItem -Filter c:\PostPatching\*.csv | Select-Object -ExpandProperty FullName | Import-Csv | Export-Csv .\"CombinedPatches-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))".csv -NoTypeInformation -Append

# Compress single file
Compress-Archive -Path C:\PostPatching\Combinded*.csv -DestinationPath C:\PostPatching\*.zip
Get-ChildItem -Path C:\PostPatching\Combined*.csv |
  Compress-Archive -DestinationPath C:\PostPatching\"PatchArchive-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))".zip

# Remove combined*.csv frin c:\PostPatching
Remove-Item C:\PostPatching\*.csv

#Delete files older than 6 months
$Folder = "C:\PostPatching"
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-10)} |
ForEach-Object {
   $_ | del -Force
   $_.FullName | Out-File C:\PostPatching\deletedlog.txt -Append
}

#Delete empty folders and subfolders
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {$_.PsIsContainer -eq $True} |
? {$_.getfiles().count -eq 0} |
ForEach-Object {
    $_ | del -Force
    $_.FullName | Out-File C:\PostPatching\deletedlog.txt -Append
}

# Copy merged zip file back to SFS share