Clear-Host

# Import TM1ps module
Import-Module -Name "C:\Applications\Powershell\TM1ps"

# Login
$Tm1Login = Invoke-Tm1Login -Tm1ConnectionName 'connection01'
Write-Host $Tm1Login   

TRY {
    # Do something
    $Tm1ExecuteProcess = Invoke-Tm1ProcessExecute -Tm1ConnectionName 'connection01' -Tm1ProcessName '}bedrock.server.wait' -Tm1ProcessParameters @{pLogOutput = 0; pWaitSec = 8 }
    Write-Host $Tm1ExecuteProcess
}

CATCH {
    Write-Error "$($_.Exception.Message)"
}

FINALLY {
    # Logout
    $Tm1Logout = Invoke-Tm1Logout -Tm1ConnectionName 'connection01'
    Write-Host $Tm1Logout   
}