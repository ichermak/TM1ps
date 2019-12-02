# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions to handel chores:
#   * Invoke-Tm1ChoresGet
#   * Invoke-Tm1ChoreExists
#   * Invoke-Tm1ChoreExecute
# ======================================================================================================

function Invoke-Tm1ChoreExecute { 
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .PARAMETER Tm1ChoreName
        Parameter2

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        ...

        .EXAMPLE
        Invoke-Tm1ChoreExecute -Tm1ConnectionName 'connection01' -Tm1ChoreName 'server.data.backup'

        .LINK
        https://github.com/ichermak/TM1ps
    #>

    [CmdletBinding()]
    
    PARAM (
        [Parameter(Mandatory = $true, Position = 1)] [string]$Tm1ConnectionName,
        [Parameter(Mandatory = $true, Position = 2)] [string]$Tm1ChoreName
    )

    TRY {
        # Build the rest request url
        $Tm1RestRequest = "Chores('$Tm1ChoreName')/tm1.Execute"
                
        # Execute the rest request
        $Tm1RestMethod = 'POST'   
        $Tm1ChoreExecuteResult = Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ChoreExecuteResult
}
# Export-ModuleMember -Function Invoke-Tm1ChoreExecute