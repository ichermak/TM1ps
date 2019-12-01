# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions to handel processes:
#   * Invoke-Tm1ProcessesGet
#   * Invoke-Tm1ProcessExists
#   * Invoke-Tm1ProcessExecute
# ======================================================================================================

function Invoke-Tm1ProcessExecute { 
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .PARAMETER Tm1ProcessName
        Parameter2

        .PARAMETER Tm1ProcessParameters
        Parameter3

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        ...

        .EXAMPLE
        Invoke-Tm1ProcessExecute -Tm1ConnectionName 'connection01' -Tm1ProcessName '}bedrock.server.wait' -Tm1ProcessParameters @{pLogOutput = 0; pWaitSec = 8 }

        .LINK
        https://github.com/ichermak/TM1ps
    #>

    [CmdletBinding()]
    
    PARAM (
        [Parameter(Mandatory = $true, Position = 1)][string]$Tm1ConnectionName,
        [Parameter(Mandatory = $true, Position = 2)][string]$Tm1ProcessName,
        [Parameter(Mandatory = $false, Position = 3)][hashtable]$Tm1ProcessParameters
    )

    TRY {
        # Build the rest request url
        $Tm1RestRequest = "Processes('$tm1ProcessName')/tm1.ExecuteWithReturn"
        
        # Build the body
        $Tm1RestBody = '{"Parameters":['
        foreach ($Item in $Tm1ProcessParameters.GetEnumerator()) {
            [string]$Tm1ParamName = $($Item.Key)
            [string]$Tm1ParamValue = $($Item.Value)
            $Tm1RestBody = $Tm1RestBody + '{"Name":"' + $Tm1ParamName + '", "Value":"' + $Tm1ParamValue + '"}, '
        }
        $Tm1RestBody = $Tm1RestBody.Substring(0, ($Tm1RestBody.Length - 2))
        $Tm1RestBody = $Tm1RestBody + ']}'
        
        # Execute the rest request
        $Tm1RestMethod = 'POST'   
        $Tm1ProcessExecuteResult = Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest -Tm1RestBody $Tm1RestBody
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ProcessExecuteResult
}
# Export-ModuleMember -Function Invoke-Tm1ProcessExecute