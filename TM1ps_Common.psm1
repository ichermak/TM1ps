# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Commun functions:
#   'Get-Tm1Servers',
#   'Request-Tm1Login',
#   'Request-Tm1Logout',
#   'Request-Tm1Rest',
#   'Invoke-Tm1ExcelStringReplace'
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

function Get-Tm1Servers { 
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
        $Tm1Login = Request-Tm1Login -Tm1ConnectionName 'connection01'

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
        
        # Get TM1 servers
        $Tm1Protocol = 'https'
        $Tm1HttpPortNumber = '5898'
        $Tm1RestApiUrl = $Tm1Protocol + '://' + $Tm1AdminHost + ':' + $Tm1HttpPortNumber + '/api' + '/' + $Tm1RestApiVersion
        $Tm1RestRequestUrl = $Tm1RestApiUrl + '/' + 'Servers'
        $Tm1RestRequestUrl = [System.Web.HttpUtility]::UrlPathEncode($Tm1RestRequestUrl)
        if ($PSEdition -ne 'Core') {
            $Tm1RestResult = Invoke-RestMethod -WebSession $Tm1WebSession -Method 'GET' -Headers $Tm1Headers -uri $Tm1RestRequestUrl
        } 
        else {
            $Tm1RestResult = Invoke-RestMethod -WebSession $Tm1WebSession -SkipCertificateCheck -Method 'GET' -Headers $Tm1Headers -uri $Tm1RestRequestUrl
        }
        $Tm1RestResult = $Tm1RestResult.value
    } 
    CATCH {
        Write-Error "$($_.Exception.Message)`n$($_.ErrorDetails.Message)"
        Break
    }
    return $Tm1RestResult
}

function Request-Tm1Login { 
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
        $Tm1Login = Request-Tm1Login -Tm1ConnectionName 'connection01'

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

    return $Tm1LoginResult
}

function Request-Tm1Logout { 
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
        $Tm1Logout = Request-Tm1Logout -Tm1ConnectionName 'connection01'

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

    return $Tm1LogoutResult
}

function Request-Tm1Rest { 
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
        Request-Tm1Rest -Tm1ConnectionName 'connection01' -Tm1RestMethod 'GET' -Tm1RestRequest 'Cubes?$select=Name&$expand=Dimensions($select=Name)'

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
    
    return $Tm1RestRequestResult
}

function Invoke-Tm1ExcelStringReplace {
    <#
        .SYNOPSIS
        ...

        .DESCRIPTION
        ...

        .PARAMETER Tm1FilePath
        Parameter 1

        .PARAMETER Tm1OldString
        Parameter 2
        
        .PARAMETER Tm1NewString
        Parameter 3
        
        .PARAMETER Tm1DestinationPath
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
        [Parameter(Mandatory = $true, Position = 1)] [ValidateScript({Test-Path $_ -PathType Any})] [System.IO.DirectoryInfo]$Tm1FilePath,
        [Parameter(Mandatory = $true, Position = 2)] [STRING]$Tm1OldString,
        [Parameter(Mandatory = $true, Position = 3)] [STRING]$Tm1NewString,
        [Parameter(Mandatory = $false, Position = 4)] [System.IO.DirectoryInfo]$Tm1DestinationPath
    )

    TRY {
        # Test if Tm1DestinationPath is empty use the same folder as Tm1FilePath
        if (-Not ($Tm1DestinationPath)) {
            if (Test-Path $Tm1FilePath -PathType Container) {
                $Tm1DestinationPath = $Tm1FilePath
            }
            else {
                $Tm1DestinationPath = Split-Path $Tm1FilePath
            }
        }
        $Tm1DestinationPath = [System.IO.DirectoryInfo]($Tm1DestinationPath.Parent.FullName + "\" + $Tm1DestinationPath.Name)
        
        # Set a unique temporary path
        $Tm1TempPath = $Tm1DestinationPath.FullName + "\" + "Temp_" + (Get-Random).ToString()
        while (Test-Path $Tm1TempPath -PathType Container) {
            $Tm1TempPath = $Tm1DestinationPath.FullName + "\" + "Temp_" + (Get-Random).ToString()
        }

        # Get the excel files collection
        $Tm1ExcelFiles =  get-childitem -Path $Tm1FilePath -Recurse -File | Where-Object {$_.fullName -Match '.xls'}
        
        foreach ($Tm1ExcelFile in $Tm1ExcelFiles) {
            
            # Expand the excel file to temp folder
            Expand-Archive -Path $Tm1ExcelFile.fullName -DestinationPath $Tm1TempPath -Force

            # Search substring and replace it            
            $XmlFiles = get-childitem -Path $Tm1DestinationPath -Recurse -File | Where-Object {$_.fullName -Match '.xml'}
            foreach ($XmlFile in $XmlFiles) {    
                if (-Not ($XmlFile.Name -eq '[Content_Types].xml')) {
                    (Get-Content $XmlFile.fullName) | Foreach-Object {$_ -replace $Tm1OldString, $Tm1NewString} | Set-Content $XmlFile.fullName
                }
            }

            # Compress the content of the temp folder
            $Tm1ExcelFile = $Tm1DestinationPath.FullName + '\' + $Tm1ExcelFile.Name
            Get-ChildItem -Path $Tm1TempPath | Compress-Archive -DestinationPath $Tm1ExcelFile -CompressionLevel NoCompression -Force
        }
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
        # Delete the temp folder
        if (Test-Path $Tm1TempPath) {
            Remove-Item -Path $Tm1TempPath -Recurse -Force
        }
    }
}