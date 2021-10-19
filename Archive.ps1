Get-childItem -Path c:\working -recurse |
  Compress-Archive -DestinationPath C:\Zip\DiskspaceLog.zip
  ls C:\Zip\DiskspaceLog.zip | ? { !$_.PSIsContainer   -and   $_.extension -eq '.zip' } |   ren -NewName { "$($_.BaseName) $(get-date -format "yyyy-mm-%d-%H-%M-%S")$($_.extension) "  }  
  Remove-Item -Path C:\working\archive\*.txt