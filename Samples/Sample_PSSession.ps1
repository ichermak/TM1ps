Clear-Host
Enable-PSRemoting
# Get-Location
$tm1PsSession = New-PSSession
Invoke-Command -Session $tm1PsSession -FilePath ".\Samples\Get_Cubes_and_Dimensions.ps1"