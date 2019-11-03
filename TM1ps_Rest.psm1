# #################################################################################################################################
# NAME : Rest
#
# DESCRIPTION : This module contains functions that wrapp TM1 Rest API
#
# LAST UPDATE : 2019/10/31
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
        Permet de lancer une requete Rest pour TM1.

        .DESCRIPTION
        Ce module a pour but de simplifier l'utilisation l'Api Rest de TM1 en powershell.

        .PARAMETER configFilePath
        Parameter 1

        .PARAMETER serverName
        Parameter 2

        .PARAMETER tm1RestRequest
        Parameter3

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        System.String. Add-Extension returns a string with the extension
        or file name.

        .NOTES
        None.

        .EXAMPLE
        PS> extension -name "File"
        File.txt

        .EXAMPLE
        PS> extension -name "File" -extension "doc"
        File.doc

        .EXAMPLE
        PS> extension "File" "doc"
        File.doc

        .LINK
        https://github.com/ichermak/TM1ps
    #>
    
    PARAM 
    (
        [Parameter(Mandatory = $true)][STRING]$configFilePath,
        [Parameter(Mandatory = $true)][STRING]$tm1ServerName,
        [Parameter(Mandatory = $true)][STRING]$tm1RestRequest
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

        # Build the rest request
        $headers = @{"Authorization" = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($tm1User):$($tm1UserPassword)")); }
        $tm1RestApiUrl = "https://" + $tm1AdminHost + ":" + $tm1HttpPort + "/api/v1/"
        
        $tm1RestFullUrl = $tm1RestApiUrl + $tm1RestRequest

        # Execute the rest request
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $tm1RestResult = Invoke-RestMethod -Method Get -uri $tm1RestFullUrl -WebSession $session -Headers $headers
    }

    CATCH 
    {
        # Do somthing
    }

    FINALLY 
    {
        # Do somthing
    }
    
    return $tm1RestResult
}
Export-ModuleMember -Function Invoke-Tm1RestRequest
