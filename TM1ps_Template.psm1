# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions <description>: 
#   * <Function1>
#   * <Function2>
#   * <Function2>
# ======================================================================================================

function Invoke-Tm1Function {
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1Parameter1
        Parameter 1

        .PARAMETER Tm1Parameter2
        Parameter 2

        .PARAMETER Tm1Parameter3
        Parameter 3

        .PARAMETER Tm1Parameter3
        Parameter 4

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        ...

        .EXAMPLE
        ...

        .LINK
        https://github.com/ichermak/TM1ps
    #>

    [CmdletBinding()]

    PARAM (
        [Parameter(Mandatory = $true, Position = 1)][STRING]$Tm1Parameter1,
        [Parameter(Mandatory = $true, Position = 2)][STRING]$Tm1Parameter2,
        [Parameter(Mandatory = $true, Position = 3)][STRING]$Tm1Parameter3,
        [Parameter(Mandatory = $true, Position = 4)][STRING]$Tm1Parameter4
    )

    TRY {
        # DoSomthing
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1FunctionResult
}
# Export-ModuleMember -Function Invoke-Tm1Function