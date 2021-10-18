$dir = "c:\working\archive"
if (c:\working\archive)
{
  New-Item -Path 'C:\working\archive' -ItemType Directory
}
else
{
  write-host "folder already exists"
}
#Copy-Item 'C:\working\DiskSpace.txt' 'C:\working\archive\DiskSpace.txt'
#ls C:\working\archive\DiskSpace.txt | ? { !$_.PSIsContainer   -and   $_.extension -eq '.txt' } |   ren -NewName { "$($_.BaseName) $(get-date -format "yyyymm%d%H%M%S")$($_.extension) "  }

if(Test-Path C:\working\DiskSpace.txt){
$destination = "C:\working\archive\DiskSpace.txt"+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+".txt"
Copy-Item -Path C:\working\archive\DiskSpace.txt -Destination $destination
}
