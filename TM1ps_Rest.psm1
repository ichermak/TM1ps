# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Functions that provide easy use of the TM1 Rest API:
#   * Invoke-Tm1Login
#   * Invoke-Tm1Logout
#   * Invoke-Tm1RestRequest
# ======================================================================================================

# Module variables
$Tm1RestApiVersion = 'v1'
$Tm1Connections = (Get-Content "$PSScriptRoot\config.JSON" | ConvertFrom-Json).connections
$Tm1WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# To disregard the certificate
if ($PSEdition -ne 'Core') {
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
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
    [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
}

function Invoke-Tm1Login { 
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        ...

        .EXAMPLE
        $Tm1Login = Invoke-Tm1Login -Tm1ConnectionName 'connection01'

        .LINK
        https://github.com/ichermak/TM1ps
    #>

    [CmdletBinding()]
    
    PARAM (
        [Parameter(Mandatory = $true)] [STRING]$Tm1ConnectionName
    )
    
    TRY {    
        # Get informations from the config file
        $Tm1AdminHost = $Tm1Connections.$Tm1ConnectionName.adminhost
        $Tm1HttpPortNumber = $Tm1Connections.$Tm1ConnectionName.httpportnumber
        $Tm1User = $Tm1Connections.$Tm1ConnectionName.user
        $Tm1Password = $Tm1Connections.$Tm1ConnectionName.password
        $Tm1UseSsl = $Tm1Connections.$Tm1ConnectionName.usessl
        $Tm1CamNameSpace = $Tm1Connections.$Tm1ConnectionName.camnamespace

        # Set Authorization
        if ($Tm1CamNameSpace) {
            $Tm1Headers = @{
                "Authorization" = 'CAMNamespace ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($Tm1User):$($Tm1Password)")); 
                "Content-Type"  = "application/json"
            }
        }
        else {
            $Tm1Headers = @{
                "Authorization" = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($Tm1User):$($Tm1Password)")); 
                "Content-Type"  = "application/json"
            } 
        }
        
        # Set Protocol
        if ($Tm1UseSsl.ToLower() -eq 'true') {
            $Tm1Protocol = "https"
        }
        else {
            $Tm1Protocol = "http"
        }

        # Establish the connection
        $Tm1RestApiUrl = $Tm1Protocol + "://" + $Tm1AdminHost + ":" + $Tm1HttpPortNumber + "/api"
        $Tm1RestRequestUrl = $Tm1RestApiUrl + '/' + $Tm1RestApiVersion + '/' + 'ActiveSession'
        $Tm1RestRequestUrl = [System.Web.HttpUtility]::UrlPathEncode($Tm1RestRequestUrl)
        if ($PSEdition -ne 'Core') {
            $Tm1LoginResult = Invoke-RestMethod -WebSession $Tm1WebSession -Method 'GET' -Headers $Tm1Headers -uri $Tm1RestRequestUrl
        } 
        else {
            $Tm1LoginResult = Invoke-RestMethod -WebSession $Tm1WebSession -SkipCertificateCheck -Method 'GET' -Headers $Tm1Headers -uri $Tm1RestRequestUrl
        }
    } 

    CATCH {
        Write-Error "$($_.Exception.Message)`n$($_.ErrorDetails.Message)"
        Break
    }

    FINALLY {

    }
    
    return $Tm1LoginResult
}

function Invoke-Tm1Logout { 
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        ...

        .EXAMPLE
        $Tm1Logout = Invoke-Tm1Logout -Tm1ConnectionName 'connection01'

        .LINK
        https://github.com/ichermak/TM1ps
    #>

    [CmdletBinding()]
    
    PARAM (
        [Parameter(Mandatory = $true)] [STRING]$Tm1ConnectionName
    )
    
    TRY {    
        # Get informations from the config file
        $Tm1AdminHost = $Tm1Connections.$Tm1ConnectionName.adminhost
        $Tm1HttpPortNumber = $Tm1Connections.$Tm1ConnectionName.httpportnumber
        $Tm1UseSsl = $Tm1Connections.$Tm1ConnectionName.usessl
 
        # Set Protocol
        if ($Tm1UseSsl.ToLower() -eq 'true') {
            $Tm1Protocol = "https"
        }
        else {
            $Tm1Protocol = "http"
        }

        # Logout        
        $Tm1RestApiUrl = $Tm1Protocol + "://" + $Tm1AdminHost + ":" + $Tm1HttpPortNumber + "/api"
        $Tm1RestRequestUrl = $Tm1RestApiUrl + '/' + 'logout'
        $Tm1RestRequestUrl = [System.Web.HttpUtility]::UrlPathEncode($Tm1RestRequestUrl)
        if ($PSEdition -ne 'Core') {
            $Tm1LogoutResult = Invoke-RestMethod -WebSession $Tm1WebSession -Method 'GET' -uri $Tm1RestRequestUrl
        }
        else {
            $Tm1LogoutResult = Invoke-RestMethod -WebSession $Tm1WebSession -SkipCertificateCheck -Method 'GET' -uri $Tm1RestRequestUrl
        }
    } 

    CATCH {
        Write-Error "$($_.Exception.Message)`n$($_.ErrorDetails.Message)"
        Break
    }

    FINALLY {

    }
    
    return $Tm1LogoutResult
}

function Invoke-Tm1RestRequest { 
    <#
        .SYNOPSIS
        Allows to launch Tm1 Rest request.

        .DESCRIPTION
        Allows to launch Tm1 Rest request using a connection specified in the configuration file.

        .PARAMETER Tm1ConnectionName
        Parameter 1

        .PARAMETER Tm1RestMethod
        Parameter 2

        .PARAMETER Tm1RestRequest
        Parameter 3

        .PARAMETER Tm1RestBody
        Parameter 4

        .INPUTS
        None. You cannot pipe objects to this function.

        .OUTPUTS
        ...

        .EXAMPLE
        Invoke-Tm1RestRequest -Tm1ConnectionName 'connection01' -Tm1RestMethod 'GET' -Tm1RestRequest 'Cubes?$select=Name&$expand=Dimensions($select=Name)'

        .LINK
        https://github.com/ichermak/TM1ps
    #>

    [CmdletBinding()]

    PARAM (
        [Parameter(Mandatory = $true, Position = 1)] [STRING]$Tm1ConnectionName,
        [Parameter(Mandatory = $true, Position = 2)] [STRING]$Tm1RestMethod,
        [Parameter(Mandatory = $true, Position = 3)] [STRING]$Tm1RestRequest,
        [Parameter(Mandatory = $false, Position = 4)] [STRING]$Tm1RestBody
    )

    TRY {
        # Get informations from the config file
        $Tm1AdminHost = $Tm1Connections.$Tm1ConnectionName.adminhost
        $Tm1HttpPortNumber = $Tm1Connections.$Tm1ConnectionName.httpportnumber
        $Tm1UseSsl = $Tm1Connections.$Tm1ConnectionName.usessl

        # Set Protocol
        if ($Tm1UseSsl.ToLower() -eq 'true') {
            $Tm1Protocol = "https"
        }
        else {
            $Tm1Protocol = "http"
        }
        
        # Build the rest request url
        $Tm1RestApiUrl = $Tm1Protocol + "://" + $Tm1AdminHost + ":" + $Tm1HttpPortNumber + "/api"
        $Tm1RestRequestUrl = $Tm1RestApiUrl + '/' + $Tm1RestApiVersion + '/' + $Tm1RestRequest
        $Tm1RestRequestUrl = [System.Web.HttpUtility]::UrlPathEncode($Tm1RestRequestUrl)
        
        # Execute the rest request
        if ($Tm1RestBody) {
            if ($PSEdition -ne 'Core') {
                $Tm1RestRequestResult = Invoke-RestMethod -WebSession $Tm1WebSession -Method $Tm1RestMethod -uri $Tm1RestRequestUrl -Body $Tm1RestBody
            }
            else {
                $Tm1RestRequestResult = Invoke-RestMethod -WebSession $Tm1WebSession -SkipCertificateCheck -Method $Tm1RestMethod -uri $Tm1RestRequestUrl -Body $Tm1RestBody
            }
        }
        else {
            if ($PSEdition -ne 'Core') {
                $Tm1RestRequestResult = Invoke-RestMethod -WebSession $Tm1WebSession -Method $Tm1RestMethod -uri $Tm1RestRequestUrl
            }
            else {
                $Tm1RestRequestResult = Invoke-RestMethod -WebSession $Tm1WebSession -SkipCertificateCheck -Method $Tm1RestMethod -uri $Tm1RestRequestUrl
            }
        }
    }

    CATCH {
        Write-Error "$($_.Exception.Message)`n$($_.ErrorDetails.Message)"
        Break
    }

    FINALLY {

    }
    
    return $Tm1RestRequestResult
}
