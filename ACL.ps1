Set-Location C:\Users
Get-ChildItem -Recurse | where-object {($_.PsIsContainer)} | Get-ACL | Format-List | Out-file C:\working\ACL.txt
