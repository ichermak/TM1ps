Import-Module ".\TM1ps_Rest.psm1" 
$Cubes = (Invoke-Tm1RestRequest -configFilePath '.\config.ini' -tm1ServerName 'tm1srv01' -tm1RestRequest 'Cubes?$select=Name&$expand=Dimensions($select=Name)').value
Foreach ($Cube in  $Cubes)
{
    $Dimensions = $Cube.Dimensions
    Foreach ($Dimension in $Dimensions)
    {
        Write-Host $Cube.name";"$Dimension.name
    }
}
