# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions to handel subsests: 
#   * Invoke-Tm1SubsetsGet
#   * Invoke-Tm1SubsetExists
#   * Invoke-Tm1SubsetCreatebyMDX
# ======================================================================================================

function Invoke-Tm1SubsetsGet {
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .PARAMETER Tm1DimensionName
        Parameter 2

        .PARAMETER Tm1HierarchyName
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
        [Parameter(Mandatory = $true, Position = 2)] [STRING]$Tm1DimensionName,
        [Parameter(Mandatory = $false, Position = 3)] [STRING]$Tm1HierarchyName
    )

    TRY {
        # Test the hierarchy parameter
        if ( !$Tm1HierarchyName ) {
            $Tm1HierarchyName = $Tm1DimensionName
        }

        # Build the rest request url
        $Tm1RestRequest = "Dimensions('$Tm1DimensionName')/Hierarchies('$Tm1HierarchyName')/Subsets"
        
        # Execute the rest request
        $Tm1RestMethod = 'GET'   
        $Tm1SubsetsGetResult = (Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest).value
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1SubsetsGetResult
}
# Export-ModuleMember -Function Invoke-Tm1SubsetsGet

function Invoke-Tm1SubsetExists {
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .PARAMETER Tm1SubsetName
        Parameter 2

        .PARAMETER Tm1DimensionName
        Parameter 3

        .PARAMETER Tm1HierarchyName
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
        [Parameter(Mandatory = $true, Position = 1)] [STRING]$Tm1ConnectionName,
        [Parameter(Mandatory = $true, Position = 2)] [STRING]$Tm1SubsetName,
        [Parameter(Mandatory = $true, Position = 3)] [STRING]$Tm1DimensionName,
        [Parameter(Mandatory = $false, Position = 4)] [STRING]$Tm1HierarchyName
    )

    TRY {
        # Get subset names
        $Tm1SubsetNames = (Invoke-Tm1SubsetsGet -Tm1ConnectionName $Tm1ConnectionName -Tm1DimensionName $Tm1DimensionName -Tm1HierarchyName $Tm1HierarchyName).Name
        
        # Test if subset exists   
        $Tm1SubsetExistsResult = $Tm1SubsetNames -contains $Tm1SubsetName
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1SubsetExistsResult
}
# Export-ModuleMember -Function Invoke-Tm1SubsetExists

function Invoke-Tm1SubsetCreatebyMDX {
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .PARAMETER Tm1SubsetName
        Parameter 2

        .PARAMETER Tm1DimensionName
        Parameter 3

        .PARAMETER Tm1HierarchyName
        Parameter 4

        .PARAMETER Tm1Mdx
        Parameter 5

        .PARAMETER Tm1Overwrite
        Parameter 6

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
        [Parameter(Mandatory = $true, Position = 2)] [STRING]$Tm1SubsetName,
        [Parameter(Mandatory = $true, Position = 3)] [STRING]$Tm1DimensionName,
        [Parameter(Mandatory = $false, Position = 4)] [STRING]$Tm1HierarchyName,
        [Parameter(Mandatory = $true, Position = 5)] [STRING]$Tm1Mdx,
        [Parameter(Mandatory = $false, Position = 5)] [BOOLEAN]$Tm1Overwrite = $false
    )

    TRY {
        # Test the hierarchy parameter
        if ( !$Tm1HierarchyName ) {
            $Tm1HierarchyName = $Tm1DimensionName
        }

        # Test if subset exists
        $Tm1SubsetExists = Invoke-Tm1SubsetExists -Tm1ConnectionName $Tm1ConnectionName -Tm1SubsetName $Tm1SubsetName -Tm1DimensionName $Tm1DimensionName -Tm1HierarchyName $Tm1HierarchyName

        if ($Tm1SubsetExists -And $Tm1Overwrite) {
            # Build the rest request url
            $Tm1RestRequest = "Dimensions('$Tm1DimensionName')/Hierarchies('$Tm1HierarchyName')/Subsets('$Tm1SubsetName')"
            
            # Build the body
            $Tm1RestBody = '{"Expression": "' + $Tm1Mdx + '"}'

            # Execute the rest request
            $Tm1RestMethod = 'PATCH'
            $Tm1SubsetCreatebyMDXResult = Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest -Tm1RestBody $Tm1RestBody
        }
        else {
            # Build the rest request url
            $Tm1RestRequest = "Dimensions('$Tm1DimensionName')/Hierarchies('$Tm1HierarchyName')/Subsets"
            
            # Build the body
            $Tm1RestBody = '{"Name": "' + $Tm1SubsetName + '", "Expression": "' + $Tm1Mdx + '"}'

            # Execute the rest request
            $Tm1RestMethod = 'POST'
            $Tm1SubsetCreatebyMDXResult = Invoke-Tm1RestRequest -Tm1ConnectionName $Tm1ConnectionName -Tm1RestMethod $Tm1RestMethod -Tm1RestRequest $Tm1RestRequest -Tm1RestBody $Tm1RestBody
        } 
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        
    }
    
    return $Tm1SubsetCreatebyMDXResult
}
# Export-ModuleMember -Function Invoke-Tm1SubsetCreatebyMDX