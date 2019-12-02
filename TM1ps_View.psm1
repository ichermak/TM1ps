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

function Invoke-Tm1ViewsGet {
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1
        
        .PARAMETER Tm1CubeName
        Parameter 2

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
        [Parameter(Mandatory = $true, Position = 1)] [STRING]$Tm1ConnectionName,
        [Parameter(Mandatory = $true, Position = 2)] [STRING]$Tm1CubeName
    )

    TRY {
        # Build the rest request url
        $Tm1RestRequest = "Cubes('$Tm1CubeName')/Views"
        
        # Execute the rest request
        $Tm1RestMethod = 'GET'
        $Tm1ViewsGetResult = (Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest).value
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ViewsGetResult
}
# Export-ModuleMember -Function Invoke-Tm1ViewsGet

function Invoke-Tm1ViewExists {
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
        [Parameter(Mandatory = $true, Position = 1)] [STRING]$Tm1ConnectionName,
        [Parameter(Mandatory = $true, Position = 2)] [STRING]$Tm1ViewName,
        [Parameter(Mandatory = $true, Position = 3)] [STRING]$Tm1CubeName
    )

    TRY {
        # Get view names
        $Tm1ViewNames = (Invoke-Tm1ViewsGet -Tm1ConnectionName $Tm1ConnectionName -Tm1CubeName $Tm1CubeName).Name
        
        # Test if view exists
        $Tm1ViewExistsResult = $Tm1ViewNames -contains $Tm1ViewName
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ViewExistsResult
}
# Export-ModuleMember -Function Invoke-Tm1ViewExists

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

        .PARAMETER Tm1Overwrite
        Parameter 5

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
        [Parameter(Mandatory = $true, Position = 1)] [STRING]$Tm1ConnectionName,
        [Parameter(Mandatory = $true, Position = 2)] [STRING]$Tm1ViewName,
        [Parameter(Mandatory = $true, Position = 3)] [STRING]$Tm1CubeName,
        [Parameter(Mandatory = $true, Position = 4)] [STRING]$Tm1Mdx,
        [Parameter(Mandatory = $false, Position = 5)] [BOOLEAN]$Tm1Overwrite = $false
    )

    TRY {
        # Build the rest request url
        $Tm1RestRequest = "Cubes('$Tm1CubeName')/Views"
        
        # Build the body
        $Tm1RestBody = '{"@odata.type": "ibm.tm1.api.v1.MDXView", "Name": "' + $Tm1ViewName + '", "MDX" : "' + $Tm1Mdx + '"}'

        # Test if view exists 
        $Tm1ViewExists = Invoke-Tm1ViewExists -Tm1ConnectionName $Tm1ConnectionName -Tm1ViewName $Tm1ViewName -Tm1CubeName $Tm1CubeName

        # Execute the rest request
        if ($Tm1ViewExists -And $Tm1Overwrite) {
            $Tm1RestMethod = 'PATCH'
        }
        else {
            $Tm1RestMethod = 'POST'   
        }
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