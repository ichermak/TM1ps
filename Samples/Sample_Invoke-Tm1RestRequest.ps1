Clear-Host

# Import TM1ps module
Import-Module -Name "C:\Applications\Powershell\TM1ps"

# Login
$Tm1Login = Invoke-Tm1Login -Tm1ConnectionName 'connection01'
Write-Host $Tm1Login   

TRY {
    # Do something
    $Cubes = (Invoke-Tm1RestRequest -Tm1ConnectionName 'connection01' -Tm1RestMethod 'GET' -Tm1RestRequest 'Cubes?$select=Name&$expand=Dimensions($select=Name)').value
    Foreach ($Cube in  $Cubes)
    {
        $Dimensions = $Cube.Dimensions
        foreach ($Dimension in $Dimensions)
        {
            Write-Host $Cube.name";"$Dimension.name
        }
    }
}

CATCH {
    Write-Error "$($_.Exception.Message)"
}

FINALLY {
    # Logout
    $Tm1Logout = Invoke-Tm1Logout -Tm1ConnectionName 'connection01'
    Write-Host $Tm1Logout   
}