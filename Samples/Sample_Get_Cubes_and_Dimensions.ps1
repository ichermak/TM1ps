Clear-Host
Import-Module -Name "C:\Applications\Powershell\TM1ps"
$Cubes = (Invoke-Tm1RestRequest -restMethod 'GET' -configFilePath 'C:\Applications\Powershell\TM1ps\config.JSON' -tm1ServerName 'tm1srv01' -tm1RestRequest 'Cubes?$select=Name&$expand=Dimensions($select=Name)').value
Foreach ($Cube in  $Cubes)
{
    $Dimensions = $Cube.Dimensions
    Foreach ($Dimension in $Dimensions)
    {
        Write-Host $Cube.name";"$Dimension.name
    }
}