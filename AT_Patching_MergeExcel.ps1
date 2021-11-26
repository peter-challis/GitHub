# To be run from WSUS via AT
# WSUS = IFWQTV0100.test01global.lloydstsb.com

# Create new folder and over write if exists
New-Item -Path c:\PostPatching -ItemType directory -force

# Create date stamp folder for imports from endpoints
$path = "InstalledPatches-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))"
New-Item -ItemType Directory -Path $path

# copy <servername>_installed.csv from SFS server (or WSUS) to date stamped folder
# possibly only copy files with a date stamp of x

# merge all .csv files into one
Get-ChildItem -Filter $path\*.csv | Select-Object -ExpandProperty FullName | Import-Csv | Export-Csv .\"CombinedPatches-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))".csv -NoTypeInformation -Append

# Compress single file
Compress-Archive -Path C:\PostPatching\Combinded*.csv -DestinationPath C:\PostPatching\*.zip
Get-ChildItem -Path C:\PostPatching\Combined*.csv |
  Compress-Archive -DestinationPath C:\PostPatching\"PatchArchive-$((Get-Date).ToString('yyyy-MM-dd-HH-mm-ss'))".zip

# Remove combined*.csv frin c:\PostPatching
Remove-Item C:\PostPatching\*.csv

#Delete files older than 6 months
$Folder = "C:\PostPatching"
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)} |
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
