Clear-Host

# Import TM1ps module
Import-Module -Name "C:\Applications\Powershell\TM1ps"

# Login
$Tm1Login = Invoke-Tm1Login -Tm1ConnectionName 'connection01'
Write-Host $Tm1Login   

# Do something
$Cubes = (Invoke-Tm1RestRequest -Tm1ConnectionName 'connection01' -Tm1RestMethod 'GET' -Tm1RestRequest 'Cubes?$select=Name&$expand=Dimensions($select=Name)').value
Foreach ($Cube in  $Cubes)
{
    $Dimensions = $Cube.Dimensions
    Foreach ($Dimension in $Dimensions)
    {
        Write-Host $Cube.name";"$Dimension.name
    }
}

# Logout
$Tm1Logout = Invoke-Tm1Logout -Tm1ConnectionName 'connection01'
Write-Host $Tm1Logout