Remove-Module -Name TM1ps
Import-Module -Name C:\Applications\Powershell\TM1ps\TM1ps.psd1 -Verbose
Get-Command -Module TM1ps
$Tm1Servers = Get-Tm1Servers -Tm1ConnectionName 'Planning_Sample'
$Tm1Servers