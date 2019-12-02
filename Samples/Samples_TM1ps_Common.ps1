Clear-Host

# Import TM1ps module
Import-Module -Name "C:\Applications\Powershell\TM1ps"

TRY {
    # Do something
    $Tm1FilePath = "C:\Applications\Tm1\Packages"
    Invoke-Tm1ExcelStringReplace -Tm1FilePath $Tm1FilePath -Tm1OldString "InstanceName [DEV]" -Tm1NewString "InstanceName [PRD]"
}

CATCH {
    Write-Error "$($_.Exception.Message)"
}
