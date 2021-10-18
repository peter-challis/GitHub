Get-childItem -Path c:\working -recurse |
  Compress-Archive -DestinationPath C:\Zip\pipline.zip
  ls C:\Zip\pipline.zip | ? { !$_.PSIsContainer   -and   $_.extension -eq '.zip' } |   ren -NewName { "$($_.BaseName) $(get-date -format "yyyymm%d%H%M%S")$($_.extension) "  }  
  Remove-Item -Path C:\working\archive\*.txt