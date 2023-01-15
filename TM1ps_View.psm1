# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions to handel views:
#   'Get-Tm1Views',
#   'Test-Tm1View',
#   'Invoke-Tm1ViewCreateByMdx'
# ======================================================================================================

function Get-Tm1Views {
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
        $Tm1ViewsGetResult = (Request-Tm1Rest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest).value
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ViewsGetResult
}

function Test-Tm1View {
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
        $Tm1ViewNames = (Get-Tm1Views -Tm1ConnectionName $Tm1ConnectionName -Tm1CubeName $Tm1CubeName).Name
        
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
        
        # Test if view exists 
        $Tm1ViewExists = Test-Tm1View -Tm1ConnectionName $Tm1ConnectionName -Tm1ViewName $Tm1ViewName -Tm1CubeName $Tm1CubeName
        
        if ($Tm1ViewExists -And $Tm1Overwrite) {
            # Build the rest request url
            $Tm1RestRequest = "Cubes('$Tm1CubeName')/Views('$Tm1ViewName')"
            
            # Build the body
            $Tm1RestBody = '{"@odata.type": "ibm.tm1.api.v1.MDXView", "MDX" : "' + $Tm1Mdx + '"}'
            
            # Execute the rest request
            $Tm1RestMethod = 'PATCH'
            $Tm1ViewCreateByMdxResult = Request-Tm1Rest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest -Tm1RestBody $Tm1RestBody
        }
        else {
            # Build the rest request url
            $Tm1RestRequest = "Cubes('$Tm1CubeName')/Views"
            
            # Build the body
            $Tm1RestBody = '{"@odata.type": "ibm.tm1.api.v1.MDXView", "Name": "' + $Tm1ViewName + '", "MDX" : "' + $Tm1Mdx + '"}'
            
            # Execute the rest request
            $Tm1RestMethod = 'POST'
            $Tm1ViewCreateByMdxResult = Request-Tm1Rest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest -Tm1RestBody $Tm1RestBody
        }
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1ViewCreateByMdxResult
}