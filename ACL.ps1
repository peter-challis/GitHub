Get-ChildItem -Recurse | where-object {($_.PsIsContainer)} | Get-ACL | Format-List | Output C:\working\ACL.txt
