$file="C:\temp\FreeSpace.txt"
New-Item -Path $file -Force
$FreeSpace=(Get-CimInstance -Class CIM_Logicaldisk | Select-Object @{Name="FreeSpace";Expression={($_.freespace/1gb).tostring("#.#")}}, DeviceID | Where-Object DeviceID -EQ 'C:')
Add-Content -path $file "$FreeSpace"
(Get-Content $file) -replace '; DeviceID=C:}','' | Out-File -filepath $file