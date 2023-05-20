# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions to handel servers:
#   'Get-Tm1ServerConfiguration'
# ======================================================================================================

function Get-Tm1ServerConfiguration {
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
        [Parameter(Mandatory = $true, Position = 1)] [STRING]$Tm1ConnectionName
    )

    TRY {
        # Build the rest request url
        $Tm1RestRequest = "Configuration"
        
        # Execute the rest request
        $Tm1RestMethod = 'GET'   
        $Tm1ServerConfigurationGetResult = Request-Tm1Rest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }
    
    return $Tm1ServerConfigurationGetResult
}