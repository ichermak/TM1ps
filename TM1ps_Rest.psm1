# #################################################################################################################################
# NAME : Rest
#
# DESCRIPTION : This module contains functions that wrapp TM1 Rest API
#
# LAST UPDATE : 2019/11/04
# #################################################################################################################################

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@

function Invoke-Tm1RestRequest 
{ 
    <#
        .SYNOPSIS
        Allows to launch Tm1 Rest request.

        .DESCRIPTION
        Allows to launch Tm1 Rest request using the informations stored in the config.ini.

        .PARAMETER restMethod
        Parameter 1

        .PARAMETER configFilePath
        Parameter 2

        .PARAMETER tm1ServerName
        Parameter 3

        .PARAMETER tm1RestRequest
        Parameter 4

        .PARAMETER tm1RestBody
        Parameter 5

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
        [Parameter(Mandatory = $true)][STRING]$restMethod,
        [Parameter(Mandatory = $true)][STRING]$configFilePath,
        [Parameter(Mandatory = $true)][STRING]$tm1ServerName,
        [Parameter(Mandatory = $true)][STRING]$tm1RestRequest,
        [Parameter(Mandatory = $false)][STRING]$tm1RestBody
    )

    TRY 
    {
        # Modules importation
        Import-Module ".\TM1ps_Common.psm1"

        # To disregard the certificate        
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

        # Get informations from the config.ini file
        $tm1AdminHost = (Get-IniContent -filePath $configFilePath).$tm1ServerName.address
        $tm1HttpPort = (Get-IniContent -filePath $configFilePath).$tm1ServerName.port
        $tm1User = (Get-IniContent -filePath $configFilePath).$tm1ServerName.user
        $tm1UserPassword = (Get-IniContent -filePath $configFilePath).$tm1ServerName.password
        $tm1UserSsl = (Get-IniContent -filePath $configFilePath).$tm1ServerName.ssl.ToLower()

        # Build the rest request
        $headers = @{
                        "Authorization" = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($tm1User):$($tm1UserPassword)")); 
                        "Content-Type" = "application/json"
                    }
        if ($tm1UserSsl.ToLower() = 'true')
        {
            $tm1Protocol = "https"
        }
        else 
        {
            $tm1Protocol = "http"
        }
        $tm1RestApiUrl = $tm1Protocol + "://" + $tm1AdminHost + ":" + $tm1HttpPort + "/api/v1/"
        $tm1RestFullUrl = $tm1RestApiUrl + $tm1RestRequest

        # Execute the rest request
        $webSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        if ($tm1RestBody)
        {
            $tm1RestRequestResult = Invoke-RestMethod -WebSession $webSession -Method $restMethod -Headers $headers -uri $tm1RestFullUrl -Body $tm1RestBody
        }
        else 
        {
            $tm1RestRequestResult = Invoke-RestMethod -WebSession $webSession -Method $restMethod -Headers $headers -uri $tm1RestFullUrl
        }
    }

    CATCH 
    {
        # Do somthing
    }

    FINALLY 
    {
        # Do somthing
    }
    
    return $tm1RestRequestResult
}
Export-ModuleMember -Function Invoke-Tm1RestRequest