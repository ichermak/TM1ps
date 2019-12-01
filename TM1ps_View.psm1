# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions to handel views:
#   * Invoke-Tm1ViewsGet
#   * Invoke-Tm1ViewExists
#   * Invoke-Tm1ViewCreateByMdx
# ======================================================================================================

function Invoke-Tm1ViewCreateByMdx {
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .PARAMETER Tm1ViewName
        Parameter 2
        
        .PARAMETER Tm1CubeName
        Parameter 3

        .PARAMETER Tm1Mdx
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
        [Parameter(Mandatory = $true, Position = 1)][STRING]$Tm1ConnectionName,
        [Parameter(Mandatory = $true, Position = 2)][STRING]$Tm1ViewName,
        [Parameter(Mandatory = $true, Position = 3)][STRING]$Tm1CubeName,
        [Parameter(Mandatory = $true, Position = 4)][STRING]$Tm1Mdx
    )

    TRY {
        # Build the rest request url
        $Tm1RestRequest = "Cubes('$Tm1CubeName')/Views"
        
        # Build the body
        $Tm1RestBody = '{"@odata.type": "ibm.tm1.api.v1.MDXView", "Name": "' + $Tm1ViewName + '", "MDX" : "' + $Tm1Mdx + '"}'

        # Execute the rest request
        $Tm1RestMethod = 'POST'   
        $Tm1ViewCreateByMdxResult = Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest -Tm1RestBody $Tm1RestBody
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ViewCreateByMdxResult
}
# Export-ModuleMember -Function Invoke-Tm1ViewCreateByMdx