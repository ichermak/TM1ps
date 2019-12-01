Clear-Host

# Import TM1ps module
Import-Module -Name "C:\Applications\Powershell\TM1ps"

# Login
$Tm1Login = Invoke-Tm1Login -Tm1ConnectionName 'connection01'
Write-Host $Tm1Login   

TRY {
  # Do something
  $Tm1SubsetsGet = Invoke-Tm1SubsetsGet -Tm1ConnectionName 'connection01' -Tm1DimensionName 'Month'
  Write-Host $Tm1SubsetsGet

  $Tm1SubsetExists = Invoke-Tm1SubsetExists -Tm1ConnectionName 'connection01' -Tm1SubsetName 'TM1ps_test' -Tm1DimensionName 'Month'
  Write-Host $Tm1SubsetExists

  $Mdx = "{TM1SUBSETALL([Month])}"

  $Tm1SubsetCreatebyMDX = Invoke-Tm1SubsetCreatebyMDX -Tm1ConnectionName 'connection01' -Tm1SubsetName 'TM1ps_test' -Tm1DimensionName 'Month' -Tm1Mdx $Mdx -Tm1Overwrite $Tm1SubsetExists
  Write-Host $Tm1SubsetCreatebyMDX

}

CATCH {
  Write-Error "$($_.Exception.Message)"
}

FINALLY {
  # Logout
  $Tm1Logout = Invoke-Tm1Logout -Tm1ConnectionName 'connection01'
  Write-Host $Tm1Logout   
}