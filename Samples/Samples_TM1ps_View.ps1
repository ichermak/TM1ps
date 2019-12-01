Clear-Host

# Import TM1ps module
Import-Module -Name "C:\Applications\Powershell\TM1ps"

# Login
$Tm1Login = Invoke-Tm1Login -Tm1ConnectionName 'connection01'
Write-Host $Tm1Login   

TRY {
  # Do something
  $Tm1ViewsGet = Invoke-Tm1ViewsGet -Tm1ConnectionName 'connection01' -Tm1CubeName 'COSTALLOC_REST_Cost_Allocation'
  Write-Host $Tm1ViewsGet

  $Tm1ViewExists = Invoke-Tm1ViewExists -Tm1ConnectionName 'connection01' -Tm1ViewName 'TM1ps_test' -Tm1CubeName 'COSTALLOC_REST_Cost_Allocation'
  Write-Host $Tm1ViewExists

  $Mdx = @"
            SELECT 
              NON EMPTY 
              {TM1SUBSETALL([Month].[Month])}
              ON COLUMNS, 
              NON EMPTY 
                {TM1SUBSETALL([Year].[Year])}
              ON ROWS 
            FROM [COSTALLOC_REST_Cost_Allocation]
            WHERE 
              (
              [Phase].[Phase].[Ytd],
              [Employee].[Employee].[Total_Employee],
              [Cost_Center].[Cost_Center].[Total_Cost_Center],
              [COSTALLOC_REST_Cost_Allocation_Measure].[COSTALLOC_REST_Cost_Allocation_Measure].[Amount],
              [COSTALLOC_REST_Cost_Allocation_KPI].[COSTALLOC_REST_Cost_Allocation_KPI].[NS]
              )
"@

  $Tm1ViewCreateByMdx = Invoke-Tm1ViewCreateByMdx -Tm1ConnectionName 'connection01' -Tm1ViewName 'TM1ps_test' -Tm1CubeName 'COSTALLOC_REST_Cost_Allocation' -Tm1Mdx $Mdx -Tm1Overwrite $Tm1ViewExists
  Write-Host $Tm1ViewCreateByMdx

}

CATCH {
  Write-Error "$($_.Exception.Message)"
}

FINALLY {
  # Logout
  $Tm1Logout = Invoke-Tm1Logout -Tm1ConnectionName 'connection01'
  Write-Host $Tm1Logout   
}