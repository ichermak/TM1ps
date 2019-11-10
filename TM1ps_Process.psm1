# ======================================================================================================
# Functions to handel processes
# ======================================================================================================

function Invoke-Tm1ExecuteProcess { 
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

        .NOTES
        None.

        .EXAMPLE
        None.

        .LINK
        https://github.com/ichermak/TM1ps
    #>
    
    PARAM (
        [Parameter(Mandatory = $true)][string]$Tm1ConnectionName,
        [Parameter(Mandatory = $true)][string]$Tm1ProcessName,
        [Parameter(Mandatory = $false)][hashtable]$Tm1ProcessParameters
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
        $Tm1ExecuteProcessResult = Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest -Tm1RestBody $Tm1RestBody
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ExecuteProcessResult
}
# Export-ModuleMember -Function Invoke-Tm1ExecuteProcess