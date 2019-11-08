function Invoke-Tm1ExecuteProcess
{ 
    <#
        .SYNOPSIS
        Allows to launch Tm1 Rest request.

        .DESCRIPTION
        Allows to launch Tm1 Rest request using the informations stored in the config.ini.

        .PARAMETER ConfigFilePath
        Parameter 1

        .PARAMETER Tm1ServerName
        Parameter 2

        .PARAMETER Tm1ProcessName
        Parameter3

        .PARAMETER Tm1ProcessParameters
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
        [Parameter(Mandatory = $true)][string]$ConfigFilePath,
        [Parameter(Mandatory = $true)][string]$Tm1ServerName,
        [Parameter(Mandatory = $true)][string]$Tm1ProcessName,
        [Parameter(Mandatory = $false)][hashtable]$Tm1ProcessParameters
    )

    TRY 
    {
        # Modules importation
        Import-Module -Name ".\TM1ps_Rest.psm1"

        # Execute the rest request
        $RestMethod = 'POST'   
        $Tm1RestRequest = "Processes('$tm1ProcessName')/tm1.Execute"
        $Tm1RestBody = '{"Parameters":['
        foreach ($Item in $Tm1ProcessParameters.GetEnumerator()) {
            [string]$Tm1ParamName = $($Item.Key)
            [string]$Tm1ParamValue = $($Item.Value)
            $Tm1RestBody = $Tm1RestBody + '{"Name":"' + $Tm1ParamName + '", "Value":"' + $Tm1ParamValue + '"}, '
        }
        $Tm1RestBody = $Tm1RestBody.Substring(0, ($Tm1RestBody.Length - 2))
        $Tm1RestBody = $Tm1RestBody + ']}'
        $Tm1ExecuteProcessResult = Invoke-Tm1RestRequest -RestMethod $RestMethod -ConfigFilePath $ConfigFilePath -Tm1ServerName $Tm1ServerName  -Tm1RestRequest $Tm1RestRequest -Tm1RestBody $Tm1RestBody
    }

    CATCH 
    {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY 
    {
        # Do something
    }
    
    return $Tm1ExecuteProcessResult
}
Export-ModuleMember -Function Invoke-Tm1ExecuteProcess