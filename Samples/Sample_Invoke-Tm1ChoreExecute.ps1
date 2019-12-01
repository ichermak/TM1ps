Clear-Host

# Import TM1ps module
Import-Module -Name "C:\Applications\Powershell\TM1ps"

# Login
$Tm1Login = Invoke-Tm1Login -Tm1ConnectionName 'connection01'
Write-Host $Tm1Login 

TRY {
    # Do something
    $Tm1ExecuteChore = Invoke-Tm1ChoreExecute -Tm1ConnectionName 'connection01' -Tm1ChoreName 'test'
    Write-Host $Tm1ExecuteChore
}

CATCH {
    Write-Error "$($_.Exception.Message)"
}

FINALLY {
    # Logout
    $Tm1Logout = Invoke-Tm1Logout -Tm1ConnectionName 'connection01'
    Write-Host $Tm1Logout   
}