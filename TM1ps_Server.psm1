# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions to handel servers:
#   * Invoke-Tm1ServerConfigurationGet
# ======================================================================================================

function Invoke-Tm1ServerConfigurationGet {
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

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
        [Parameter(Mandatory = $true, Position = 1)][STRING]$Tm1ConnectionName
    )

    TRY {
        # Build the rest request url
        $Tm1RestRequest = "Configuration"
        
        # Execute the rest request
        $Tm1RestMethod = 'GET'   
        $Tm1ServerConfigurationGetResult = Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ServerConfigurationGetResult
}
# Export-ModuleMember -Function Invoke-Tm1ServerConfigurationGet
