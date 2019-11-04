# #################################################################################################################################
# NAME : TM1ps Module Common
#
# DESCRIPTION : This module contains common functions
#
# LAST UPDATE : 2019/10/31
# #################################################################################################################################

function Get-IniContent 
{
    <#
        .SYNOPSIS
        Retrieve the content of an ini file.

        .DESCRIPTION
        Retrieve the content of an ini file.

        .PARAMETER filePath
        The ini file path.

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        System.String. Returns a string ...

        .NOTES
        None.

        .EXAMPLE
        None.

        .LINK
        https://github.com/ichermak/TM1ps
    #>
    
    PARAM 
    (
        [Parameter(Mandatory = $true)][STRING]$filePath
    )
    
    $ini = @{ }
    switch -regex -file $filePath 
    {
        "^\[(.+)\]" 
        { # Section
            $section = $matches[1]
            $ini[$section] = @{ }
            $CommentCount = 0
        }
        
        "^(;.*)$"
        { # Comment
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = “Comment” + $CommentCount
            $ini[$section][$name] = $value
        }
        
        "(.+?)\s*=(.*)" 
        { # Key
            $name, $value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    return $ini
}
Export-ModuleMember -Function Get-IniContent