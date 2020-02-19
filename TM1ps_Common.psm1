# ======================================================================================================
# _____  _      _   ___   __ 
#  | |  | |\/| / | | |_) ( (`
#  |_|  |_|  | |_| |_|   _)_)
# 
# Commun functions:
#   * Invoke-Tm1ExcelStringReplace
# ======================================================================================================

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