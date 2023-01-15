Remove-Module -Name TM1ps
Import-Module -Name C:\Applications\Powershell\TM1ps\TM1ps.psd1 -Verbose
Get-Command -Module TM1ps
$Tm1Login = Request-Tm1Login -Tm1ConnectionName 'Planning_Sample'
$Tm1Views = Get-Tm1Views -Tm1ConnectionName 'Planning_Sample' -Tm1CubeName 'plan_BudgetPlan'
$Tm1Logout = Request-Tm1Logout -Tm1ConnectionName 'Planning_Sample'