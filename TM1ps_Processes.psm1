# #################################################################################################################################
# NAME : Processes
#
# DESCRIPTION : This module contains functions that wrapp TM1 Rest API
#
# LAST UPDATE : 2019/10/31
# #################################################################################################################################

function Invoke-Tm1ExecuteProcess
{ 
    <#
        .SYNOPSIS
        Allows to launch Tm1 Rest request.

        .DESCRIPTION
        Allows to launch Tm1 Rest request using the informations stored in the config.ini.

        .PARAMETER configFilePath
        Parameter 1

        .PARAMETER tm1ServerName
        Parameter 2

        .PARAMETER tm1ProcessName
        Parameter3

        .PARAMETER tm1ProcessParameters
        Parameter3

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        System.String. Add-Extension returns a string with the extension
        or file name.

        .NOTES
        None.

        .EXAMPLE
        None.

        .LINK
        https://github.com/ichermak/TM1ps
    #>
    
    PARAM 
    (
        [Parameter(Mandatory = $true)][string]$configFilePath,
        [Parameter(Mandatory = $true)][string]$tm1ServerName,
        [Parameter(Mandatory = $true)][string]$tm1ProcessName,
        [Parameter(Mandatory = $false)][hashtable]$tm1ProcessParameters
    )

    TRY 
    {
        # Modules importation
        Import-Module ".\TM1ps_Rest.psm1"

        # Execute the rest request
        $restMethod = 'POST'   
        $tm1RestRequest = "Processes('$tm1ProcessName')/tm1.Execute"
        $tm1RestBody = '{"Parameters":['
        foreach ($item in $tm1ProcessParameters.GetEnumerator()) {
            [string]$tm1ParamName = $($item.Key)
            [string]$tm1ParamValue = $($item.Value)
            $tm1RestBody = $tm1RestBody + '{"Name":"' + $tm1ParamName + '", "Value":"' + $tm1ParamValue + '"}, '
        }
        $tm1RestBody = $tm1RestBody.Substring(1, ($tm1RestBody.Length - 3))
        $tm1RestBody = $tm1RestBody + ']}'
        # $tm1RestBody = '{"Parameters":[{"Name":"pLogOutput", "Value":"0"}, {"Name":"pWaitSec", "Value":"12"}]}'
        $tm1ExecuteProcessResult = Invoke-Tm1RestRequest -restMethod $restMethod -configFilePath $configFilePath -tm1ServerName $tm1ServerName  -tm1RestRequest $tm1RestRequest -tm1RestBody $tm1RestBody
    }

    CATCH 
    {
        # Do somthing
    }

    FINALLY 
    {
        # Do somthing
    }
    
    return $tm1ExecuteProcessResult
}
Export-ModuleMember -Function Invoke-Tm1ExecuteProcess