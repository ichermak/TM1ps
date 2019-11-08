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
        Allows to launch Tm1 Rest request using the informations stored in a configuration file.

        .PARAMETER RestMethod
        Parameter 1

        .PARAMETER ConfigFilePath
        Parameter 2

        .PARAMETER Tm1ServerName
        Parameter 3

        .PARAMETER Tm1RestRequest
        Parameter 4

        .PARAMETER Tm1RestBody
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
        [Parameter(Mandatory = $true)][STRING]$RestMethod,
        [Parameter(Mandatory = $true)][STRING]$ConfigFilePath,
        [Parameter(Mandatory = $true)][STRING]$Tm1ServerName,
        [Parameter(Mandatory = $true)][STRING]$Tm1RestRequest,
        [Parameter(Mandatory = $false)][STRING]$Tm1RestBody
    )

    TRY 
    {
        # To disregard the certificate        
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

        # Get informations from the config file
        $Tm1AdminHost = (Get-Content $ConfigFilePath | ConvertFrom-Json).$Tm1ServerName.address
        $Tm1HttpPort = (Get-Content $ConfigFilePath | ConvertFrom-Json).$Tm1ServerName.port
        $Tm1User = (Get-Content $ConfigFilePath | ConvertFrom-Json).$Tm1ServerName.user
        $Tm1UserPassword = (Get-Content $ConfigFilePath | ConvertFrom-Json).$Tm1ServerName.password
        $Tm1UseSsl = (Get-Content $ConfigFilePath | ConvertFrom-Json).$Tm1ServerName.ssl.ToLower()

        # Build the rest request
        $Headers = @{
                        "Authorization" = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($Tm1User):$($Tm1UserPassword)")); 
                        "Content-Type" = "application/json"
                    }
        if ($Tm1UseSsl.ToLower() = 'true')
        {
            $tm1Protocol = "https"
        }
        else 
        {
            $tm1Protocol = "http"
        }
        $tm1RestApiUrl = $tm1Protocol + "://" + $Tm1AdminHost + ":" + $Tm1HttpPort + "/api/v1/"
        $tm1RestFullUrl = $tm1RestApiUrl + $Tm1RestRequest

        # Execute the rest request
        $webSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        if ($Tm1RestBody)
        {
            $Tm1RestRequestResult = Invoke-RestMethod -WebSession $webSession -Method $RestMethod -Headers $Headers -uri $tm1RestFullUrl -Body $Tm1RestBody
        }
        else 
        {
            $Tm1RestRequestResult = Invoke-RestMethod -WebSession $webSession -Method $RestMethod -Headers $Headers -uri $tm1RestFullUrl
        }
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
    
    return $Tm1RestRequestResult
}
Export-ModuleMember -Function Invoke-Tm1RestRequest